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
