-------------------------------------------------------------------------------

This project is no longer maintained.

-------------------------------------------------------------------------------


_elm-interop-example_
=====================

Example Elm program, showing how to communicate with JavaScript by message-passing.


Usage
-----

First, download the project source files:

```
git clone https://github.com/mietek/elm-interop-example
```

The following instructions assume the project is located in the current working directory.

```
cd elm-interop-example
```


### Installing dependencies

An [Elm](http://elm-lang.org/) compiler and the [Node.js](https://nodejs.org/) runtime must be installed on the local machine.

The project is developed on OS X, but may support other UNIX platforms.  On OS X, system-level dependencies should be installed with the [`brew`](http://brew.sh/) tool.

```
brew install node elm
```

[Webpack](https://webpack.github.io/) is used to structure the project, supporting development and production mode builds.  ES2015 syntax is translated to JavaScript using [Babel](http://babeljs.io/).  Code quality is monitored using [JSHint](http://jshint.com/).

Use the [`npm`](https://www.npmjs.com/) tool, included with Node.js, to install project-level dependencies.

```
npm install
```


### Building the project

To build the project, give the following command:

```
npm run build
```

If the build is successful, the project is ready to run.  Start a local HTTP server:

```
npm start
```

Finally, navigate to the following address in a web browser:

[http://localhost:3000](http://localhost:3000)


Development
-----------

By default, the project is built in production mode, performing potentially time-consuming code optimisations.  This is unnecessary during development, and can be avoided by giving the following command:

```
npm run dev-build
```


### Building continuously

For additional convenience, the project source files may be continuously monitored for changes.  Changing any of the files on the local machine will cause a build to be performed automatically.

If the build is successful, any project-related web browser windows will be automatically reloaded using [_reload-browsers_](https://github.com/mietek/reload-browsers).  This is supported on OS X only, in Chrome, Firefox, and Safari, and requires installing the [`entr`](http://entrproject.org/) tool.  (See [_reload-firefox_](https://github.com/mietek/reload-firefox) for Firefox-specific instructions.)

```
brew install entr
```

To start monitoring the project for changes, give the following command:

```
bin/start
```

By default, continuous builds are performed in development mode.  This may be changed by pointing the `CONFIG` environment variable to the production configuration file:

```
CONFIG=webpack.config.js bin/start
```


About
-----

Made by [Miëtek Bak](https://mietek.io/).  Published under the BSD license.
