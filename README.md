# Pong Game

The mighty Pong Game {with a retro nostalgia}

This repository contains code of a basic 2D Pong-game which I worked on as a side projects of game development.

This is the result of my personal interest, hobby in Game development and to better understand game development codes, functions and algorithms.

**Lua** was used as the primary language for the 2D *Pong* game.

`main.lua` => contains the main structure of the game which calls upon objects from the various classes 

`Paddle.lua` => It contains the object class defination for the rectangular paddles, including geometry and size of the paddles. This is called upon in main.lua.

`Ball.lua` => It contains object class definations for the ball, it includes ball geometry, speed and size definations.

`push.lua` => This is the push library that i downloaded from web which helps in rendering the game in a virtual width and height and gives a retro overlook to the entire game.

`class.lua` => This was an already existing library file that i downloaded from web, it helps in creating the object classes like Paddle and Ball so that the defination and calling of these can be similar to OOPS.

`font.ttf` => This is a custom font which is intended to give a retro vibe to pong game.

## How to run the game

* First install love2d from the official love2d website.

* To run the game use the command "love ." from the folder that contains all the files and subfiles.

## Current Updates and work in progress {WIP}

* So currently the game requires 2 players at all time, so its a dual player dame by default. 

* We don't always have a friend who wants to play the game with us {being lonely}, so now i am trying to figure out how to computer to play with the player.

* Next step would be to add different computer difficulty levels to make the game more interesting and competitive for the single player.