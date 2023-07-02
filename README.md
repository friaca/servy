# Servy

Simple HTTP server and some unrelated exercises based on Pragmastic Studio's Elixir & OTP course.

## Running the project

Just clone the project as usual and run the following on the project's root directory.
```
mix deps.get
```
After that you can do whatever you want.

To start the server you can run the following on the project's root aswell.
```
iex -S mix
Servy.HttpServer.start(<port>)
```

If you don't specify the server port it will automatically start in port 4000.