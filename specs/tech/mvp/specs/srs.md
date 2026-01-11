`specs/tech/mvp/specs/srs.md` Should contain a comprehensive and detailed `Software requirements specification` (SRS).
Read through the following files.
* `vision/product_vision_paper.md`
* `specs/tech/mvp/specs/tech_specs.md`
* `vision/product_vision_paper.md`
* `specs/tech/mvp/specs/challenges.md`
* `research/gps_precision/intro.md`
* `specs/tech/mvp/specs/ai_features.md`

Go over the Internet and search for what an SRS document stands for and what the industry standards and best practice are for writing such a document.
Once you understood everything from this file and made a deep analysis of it Create a comprehensive software requirements specification with the knowledge you learned. Feel free to go over every file in this project to get an overview of what it's about. The software requirements specification should contain everything that is currently industry standard for such documents and should be state of the art concerning quality of the content, as well as the grade of detail and the comprehensiveness of the document. This document is really, really important because it is the bridge between planning and implementing the first Minimal Viable Product version of this service. Here is some technical information:
- It should be a web app.
- It should be written in Node.js.

Important points, questions etc.:
- Possibly the backend code should be written in Rust or Go, depending on which is a better choice. If the implementation is much easier if you also do it with Node.js, then leave Node.js.
- What are the borders of this project? What will not be implemented for now ?
- What will be implemented? Give a detailed overview.
- Look at the website in `presentation/website/splash_page` Copy design patterns, colors, etc.
- Write pseudo code to explain certain logical events in business code.
- Define guardrails of what should not be possible with the app.
- All descriptions you add for concerning functionality and scope should be as narrow as possible. Don't talk about irrelevant stuff, and give a very narrow description that leaves little room for interpretation.
- Explain what problem this application solves.
- What are the requirements of this project from a technical perspective concerning the application?
- External libraries will be used.
- Detailed description of the user interface of every page, every button. Explain where the user can log in. Explain where the user settings are orientated. Explain every screen, like the map screen. The AR screen may only be implemented in the next version, but still discuss it. I think about how the visual positioning system can be implemented, but this will also not be part of the MedibleVival product. Still discuss it; maybe it's worth a shot. Look at the following files for more information. Look within this folder. research/visual_positioning_systems.

But you should actually concentrate on the things you are going to implement in the minimal viable product version. - Describe the map screen.
- Describe the timeline screen.
- Describe the screen where the user can create messages.
- Describe how the various Spatial Primitives Will be implemented in UI but also in the backend
- Describe the database structures. Does it make sense to use a graph database? If yes, why? What kind of databases should be implemented? What is the best service to implement it for a minimal viable product? What is the best hosting provider for such a service for a minimal viable product?
- The `The Spatial Browser` Talks about the views which will be shown in the app for consuming the content. We already talked about that you need to go about them. I just want to mention it once more so you find the source on the website.
- Describe how authentication should be used and what other security measures are needed for such an app. The application should be used for the user to log in. He will have his own account. Locking in will be possible via email, Google, and Apple. Create the UI for the login, but also create the backend for the login, including the backend needed to connect to Apple and Google.
- Each user will have an account where they can change the password, change the icon which will be shown, and add two-factor authentication. See a history of all posts they created? See a map where the user posted. So he or she can see on the map where all his notifications are placed.
- In detail about the logic which will be needed on the backend
- Without locking, in the user can consume and read, but he cannot write/add content
- About the databases, how they are connected to each other and how they're connected to the backend, and how the backend is connected to the frontend
- Detail about the databases:
- Their features
- Their columns
- What tables they are
- If it makes sense to have a graph database
- What other storages are useful
- What is the best place to store it
- What technology should be used
- When you talk about the design from different pages of the app, describe everything in detail. Don't leave out the colors, the placement of the items, the arrangement of the screens. It should feel and look like a very modern website/app.

This is probably not it. I probably forgot something, but you know what an SRS is, and if some information is missing, just think of the best solution and implement that one. Also write those thoughts in the SRS document.

Make sure you express yourself in a clear and precise way, and all information you add to this document needs to be valid, true, and not just made up from yourself.

Create a very comprehensive and detailed SIS document that can be used right out of the box by the software developers to implement those ideas. On anything which it is talking about, it should go in very deep, have a lot of details, and describe everything so it can be easily implemented by the software developer team.

Use Claude flow to do this analytical research and documentation to provide the best possible outcome. You can use as many resources from Claude Flow as you want.
