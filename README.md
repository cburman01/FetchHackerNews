# FetchHackerNews
This simple application will fetch the top 50 posts from HackerNews every 5 minutes. 
Public APIS: 
/api/get_top_posts
/api/get_top_posts?page=n 
/api/get_single_post

Websocket Support
url: ws://localhost:4000/socket 
channel: room:lobby
events: 'update' will fire when server state has changed. 

This application can have as much gold platting as possible. It was written with minimal functionality to achieve a simple puropse while maintaining fault tolerence. 


To start the application:
  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `PORT=4000 mix phx.server`

Testing: 
mix test

