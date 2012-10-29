ThreadingHell
=============


### Overview

I needed to figure out a way to run multiple concurrent calls to fetch "account" 
information from a backend system.

(_I have simplified the logic for this example, but object and method names are the same_)

This sample project demonstrates how to use `dispatch_group_*` methods to provide 
run necessary code concurrently, while maintaing correct _read_ values when all 
of the tasks have finished.

### Suggestions

There are many different ways to skin this concurrent cat:

* NSOperation's
* dispatch_barrier
* dispatch semaphores

If you have a better/different implemenation then please let me know. I would like 
to add it to the list.
