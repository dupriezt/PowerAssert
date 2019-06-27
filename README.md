# PowerAssert

## Demonstration
Run the following test (available on the PowerAssertExamples class):
```Smalltalk
testPowerAssertExample1
	| array |
	array := { 2. 4. 6 }.
	self powerAssert: [ (array at: 2) % 2 ~= 0 ].
```
The usual window informing you that the test failed opens.
![image](https://user-images.githubusercontent.com/32486709/59906624-7d574a80-9409-11e9-87ce-c85d70bfa997.png)

But more interestingly, another window opens, showing you the details of the computation of the asserted expression.
It features:
- top: the asserted expression
- middle: a list of the AST nodes that were evaluated, with the value they had, in the order in which they were evaluated. Selecting an item in this list highlights the corresponding part of the asserted expression.
- bottom: a pharo inspector on the value of the selected AST node


![image](https://user-images.githubusercontent.com/32486709/59906653-8ba56680-9409-11e9-83d1-246ad158ee81.png)


![image](https://user-images.githubusercontent.com/32486709/59906941-328a0280-940a-11e9-9aec-345d55fc0273.png)


## Installation
```Smalltalk
Metacello new
    baseline: 'PowerAssert';
    repository: 'github://dupriezt/PowerAssert';
    load.
```

## Restrictions and Notes
- Some compilation optimisations throw off powerassert, giving strange results. For example, the `Number>>#to:do:` method (it is inlined by the compiler).
- The tests on the PowerAssertExamples class give the expected results, and can be used for demonstration
- The tests on the PowerAssertTest class may fail

## Power Assert Replay
You can replay an execution captured by a power assert.

### Example
The following tests picks a divisor of 60 at random and makes the division. It passes most of the time, except when 0 is picked, resulting in a ZeroDivide exception.
```Smalltalk
PowerAsserterExamples>>#testPowerAsserterReplayerExample
	| divisorsOfSixty |
	divisorsOfSixty := { 0. 1. 2. 3. 4. 5. 6. 10. 12. 15. 20. 30. 60 }.
	PowerAsserter new assert: [ (60 / (divisorsOfSixty at: divisorsOfSixty size atRandom)) isInteger ]
```
When this test fails, the PowerAssert Visualiser window opens, showing the recorded values during the assertion's execution.
In particular, we see that the value of the random index was 1, so the first diisor was selected (0).
![image](https://user-images.githubusercontent.com/32486709/60267860-6de56f00-98eb-11e9-91ca-466b409df76d.png)

To replay the buggy execution, click on the "Replay button". This opens a PowerAssert Replayer window.
![image](https://user-images.githubusercontent.com/32486709/60268056-d0d70600-98eb-11e9-84d1-92343656efa6.png)

This window behaves like a debugger on a fresh execution of the assertion. From top to bottom, it contains:
- the context stack (the top of the stack is at the top)
- stepping buttons + inspect buttons
- a view of the assertion's code
- the value stack of the selected context (the top of the stack is at the bottom)
- an inspector on the "replay value". If the node the execution is on has had a value recorded for it by PowerAssert, the recorded value will be shown in this inspector

Right now, the current node is `divisorsOfSixty size`. This result of this message-send is deterministic, so it does not matter whether you replay it or not. Click *Over*.

Now, the current node is `divisorsOfSixty size atRandom`. This message-send is *not* deterministic. You can see in the replay value inspector that the recorded value for this message is 1. Click *Over (Replay)* to use the recorded value instead of executing this message-send.

As you can see on the value stack, the top value (*i.e.* the result of the previous message-send) is indeed 1, the recorded value. If you continue to step over, you will get an exception.
![image](https://user-images.githubusercontent.com/32486709/60268849-a7b77500-98ed-11e9-8e3e-6f35d872da4f.png)
By clicking *Debug* and checking the value of the *unhandledException* variable, you can see that this exception is indeed the division by zero.
![image](https://user-images.githubusercontent.com/32486709/60269097-185e9180-98ee-11e9-9eab-48f2f05e9f07.png)

### Example (continued)
If you go back to the PowerAssert Replayer and click *Restart*, you can restart the assertion's execution. Note that this is in fact a fresh execution of the same assertion block, but with the same replay data.

This time, if you press *over* instead of *Over (Replay)* on the `atRandom` message-send you will (likely, this is random after all!) get a different index (7 on the picture). If you keep stepping over, the execution will terminate normally instead of signalling an exception.
![image](https://user-images.githubusercontent.com/32486709/60269369-9f136e80-98ee-11e9-8499-f6b1d8222907.png)

### Current Limitations
- If the same ast node is executed multiple times during the assertion, the replay will use the value of the first execution of this node when replaying **all** executions of this node.
- Step buttons work on the top context of the stack. Probably not the other contexts.
