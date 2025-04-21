# MP Report

## Student information

- Name: Sudeshna Gunjote
- AID: A20551376

## Self-Evaluation Checklist

Tick the boxes (i.e., fill them with 'X's) that apply to your submission:

- [X] The app builds without error
- [X] I tested the app in at least one of the following platforms (check all
      that apply):
  - [X] iOS simulator / MacOS
  - [] Android emulator
- [X] Users can register and log in to the server via the app
- [X] Session management works correctly; i.e., the user stays logged in after
      closing and reopening the app, and token expiration necessitates re-login
- [X] The game list displays required information accurately (for both active
      and completed games), and can be manually refreshed
- [X] A game can be started correctly (by placing ships, and sending an
      appropriate request to the server)
- [X] The game board is responsive to changes in screen size
- [X] Games can be started with human and all supported AI opponents
- [X] Gameplay works correctly (including ship placement, attacking, and game
      completion)

## Summary and Reflection

During the implementation of MP5: Battleships, I focused on modularizing the codebase using the provider package for state management and ensuring that API interactions were handled cleanly with async functions. One key design decision was to abstract API requests into separate services and use shared preferences to persist session tokens across app restarts. I made use of loading indicators and conditional rendering to handle asynchronous behavior gracefully.

One challenge I faced was handling network errors consistently across the app, especially when the server was unreachable or when the session token expired. I wasn't able to fully implement automatic token refresh upon expiration due to time constraints. I also had initial issues with connecting the frontend to the provided server, which required using a mock API for temporary testing before the official server was reachable again.

I enjoyed learning more about Flutter’s layout system and how to build responsive interfaces that work well on different screen sizes. The experience deepened my understanding of RESTful integration in mobile apps, but I wish I had known more about Flutter’s newer widgets like PopScope earlier to avoid deprecated features. Overall, it was a fun and educational project with valuable real-world mobile development experience.
