# Dagger JVM
This is a sample project that shows how to build a JVM project with Dagger.
In this case this will be a "Hello World" Ktor application (it doesn't really matter).

## Setup
To setup dagger, [install it](https://docs.dagger.io/1200/local-dev).
In our case, to avoid polluting our project structure, we will do it in a separate directory ([/dagger]).
So 
```sh
    mkdir dagger
    cd dagger
    dagger project init # Inits the project
    dagger project update # Download the dependencies
```
And now you have an empty dagger project !
