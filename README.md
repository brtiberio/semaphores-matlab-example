# semaphores-matlab-example
This is just an example how to use the java semaphore class in Matlab. 
Includes .m file and respective .fig necessary for running the example.
Matlab is build on top of java so the ideia is to take advantage of that and use functions already on java core. Read more about it [here](http://www.mathworks.com/help/matlab/matlab_external/bringing-java-classes-and-methods-into-matlab-workspace.html)


## How to use

### Run the GUI provided and hit run.

This will trigger a update function attached to a timer who will print rand() number.

### Press Hold

The semaphore will prevent the update function for three seconds After will release it and update can again print random numbers

### Hit Stop

stops the timer. You can close the figure now

## The basics behind it
first we need to tell Matlab we want to use that class:

```matlab
    import java.util.concurrent.Semaphore;
```

After we can use the class methods as typically:

```matlab
mutex = Semaphore(1);
mutex.availablePermits
```

all information about the java class is [here](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/Semaphore.html)