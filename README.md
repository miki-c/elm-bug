# Description
A simple Single-Page-Application with just two pages, named *First page* and *Second page*, respectively.  
This project demonstrates a bug that occurs when using the most recent Elm core libraries, but not when using the older libraries.  
The bug is described here: https://github.com/elm/core/issues/1128


# Preparation
You will notice the `elm.json` file is empty. Before running the app, fill the file with the contents of either `elm.json.buggy` or ` elm.json.working`. As the name suggests, only the former file causes the bug.

# Instructions
1. Install Parcel by running: `npm install`  
2. Serve the application by running: `npm run start`  
3. Open the browser at: http://localhost:1234/#/first
4. Write something in the textfield
5. Press the "Next page" button
6. Once you reach the *Second page*, press the BACK button in your browser, to navigate back to the *First page*

The textfield may or may not be automatically re-filled with what you had written before, depending on the `elm.json` file you are using (either `elm.json.buggy` or ` elm.json.working`).
