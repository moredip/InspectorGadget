# What is it
Inspector Gadget is a small library that allows you to search for DisplayObjects in a Flex application's using XPATH expressions. 

# How does it work
First inspector gadget walks the application's DOM tree - using an implementation based on [FxSpy](http://code.google.com/p/fxspy/) - and builds up an intermediary XML representation of the DOM. Then it uses [xpath-as3](http://code.google.com/p/xpath-as3/) to apply an xpath expression against that internal XML representation. If there is a match then we map the matching xml node back to the corresponding DisplayObject in the application, based on the DisplayObject's uid.

# Why would you need it
The main motivator for creating this library was to expand the element selection capabilities in [sfapi](http://code.google.com/p/sfapi/), a tool which allows automated testing of flex applications using the [Selenium](http://seleniumhq.org/) testing framework.
