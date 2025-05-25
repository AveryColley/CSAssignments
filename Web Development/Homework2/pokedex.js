/*
 * Name: Avery Colley
 * Section: CSE 154 AC
 * Date: 2/18/2022
 *
 * Allows you to play a short pokemon game in the browser and "collect" any pokemon that you
 * defeat if you do not already have them, starts you off with the 3 orginal starters
 */

"use strict";
(function() {

  window.addEventListener("load", init);
  const POKEDEX_URL = "https://courses.cs.washington.edu/courses/cse154/webservices/pokedex/pokedex.php";
  const GAME_URL = "https://courses.cs.washington.edu/courses/cse154/webservices/pokedex/game.php";
  const CRITICAL_HP = 0.2;
  let foundPokemon = [];

  /** starts the game by finding the 3 starters */
  async function init() {
    await populate();
    find("charmander");
    find("squirtle");
    find("bulbasaur");
  }

  /**
   * Checks to see if the promise given back by an API is ok, throws an error if it's not
   * @param {promise} response - resolved promise given to us by an API
   * @returns {promise} the response given
   */
  async function statusCheck(response) {
    if (!response.ok) {
      throw new Error(await response.text());
    }
    return response;
  }

  /** populates the pokedex by filling it with sprites of all 151 pokemon*/
  async function populate() {
    try {
      let response = await fetch(POKEDEX_URL + "?pokedex=all");
      await statusCheck(response);
      let fullPokedex = await response.text();
      createImages(fullPokedex);
    } catch (err) {
      console.error(err);
    }
  }

  /**
   * creates the images of the pokemon and adds them to the HTML
   * @param {string} pokedex - string in the form longName:shortName\nlongName:shortName\n...
   */
  function createImages(pokedex) {
    let shortNameArray = [];
    let fullArray = pokedex.split("\n");
    for (let i = 0; i < fullArray.length; i++) {
      let namePairArray = fullArray[i].split(":");
      let longName = namePairArray[0];
      let shortName = namePairArray[1];
      shortNameArray[i] = shortName;
      let pokemon = document.createElement("img");
      document.getElementById("pokedex-view").appendChild(pokemon);
      pokemon.src = "https://courses.cs.washington.edu/courses/cse154/webservices/pokedex/sprites/" +
      shortName + ".png";
      pokemon.alt = longName;
      shortNameArray[i] = shortName;
      pokemon.classList.add("sprite");
      pokemon.id = shortName;
    }
  }

  /**
   * "finds" a pokemon, allowing you to use it and coloring in the sprite
   * @param {string} name - the shortName of the pokemon you want to find
   */
  function find(name) {
    let pokemon = document.getElementById(name);
    pokemon.classList.add("found");
    pokemon.addEventListener("click", () => {
      fillCard(name, "p1");
    });
    foundPokemon.push(name);
  }

  /**
   * Fills the respective player's card with information about the pokemon they are using
   * @param {string} shortName - shortName of the pokemon that the player is using
   * @param {string} player - in the form p1 for player 1 and p2 for player 2
   */
  async function fillCard(shortName, player) {
    try {
      let response = await fetch(POKEDEX_URL + "?pokemon=" + shortName);
      await statusCheck(response);
      let cardInfo = await response.json();
      document.querySelector("#" + player + " .name").textContent = cardInfo.name;
      document.querySelector("#" + player + " .pokepic").src = "https://courses.cs.washington.edu/courses/cse154/webservices/pokedex/" +
      cardInfo.images.photo;
      document.querySelector("#" + player + " .type").src = "https://courses.cs.washington.edu/courses/cse154/webservices/pokedex/" +
      cardInfo.images.typeIcon;
      document.querySelector("#" + player + " .weakness").src = "https://courses.cs.washington.edu/courses/cse154/webservices/pokedex/" +
      cardInfo.images.weaknessIcon;
      document.querySelector("#" + player + " .hp").textContent = cardInfo.hp + "HP";
      document.querySelector("#" + player + " .info").textContent = cardInfo.info.description;
      buttonActivation(player, shortName, cardInfo);
    } catch (err) {
      console.error(err);
    }
  }

  /**
   * Activates the moves buttons and the start game button for player 1
   * @param {string} player - in the form p1 for player 1 and p2 for player 2
   * @param {string} pokemonName - shortName of the pokemon that the given player is using
   * @param {json} cardInfo - contains all of the relevant information for the pokemon's card
   */
  function buttonActivation(player, pokemonName, cardInfo) {
    let moveArray = document.querySelectorAll("#" + player + " .moves button");
    for (let i = 0; i < cardInfo.moves.length; i++) {
      moveArray[i].classList.remove("hidden");
      moveArray[i].querySelector(".dp").textContent = "";
      moveArray[i].querySelector(".move").textContent = cardInfo.moves[i].name;
      moveArray[i].querySelector("img").src = "https://courses.cs.washington.edu/courses/cse154/webservices/pokedex/icons/" +
      cardInfo.moves[i].type + ".jpg";
      if (cardInfo.moves[i].dp) {
        moveArray[i].querySelector(".dp").textContent = cardInfo.moves[i].dp + " DP";
      }
    }
    for (let i = moveArray.length; i > (moveArray.length - (moveArray.length -
      cardInfo.moves.length)); i--) {
      moveArray[i - 1].classList.add("hidden");
    }
    clearEventListeners(document.getElementById("start-btn"));
    document.getElementById("start-btn").addEventListener("click", () => {
      startGame(pokemonName);
    });
    if (player === "p1") {
      document.getElementById("start-btn").classList.remove("hidden");
    }
  }

  /**
   * Starts the game by hiding/showing all the unnecessary/necessary parts
   * @param {string} pokemonName - shortName of the pokemon that player 1 is using
   */
  async function startGame(pokemonName) {
    document.getElementById("pokedex-view").classList.add("hidden");
    document.getElementById("p2").classList.remove("hidden");
    document.querySelector("#p1 .hp-info").classList.remove("hidden");
    document.getElementById("results-container").classList.remove("hidden");
    document.getElementById("p1-turn-results").classList.remove("hidden");
    document.getElementById("p2-turn-results").classList.remove("hidden");
    document.getElementById("flee-btn").classList.remove("hidden");
    document.getElementById("start-btn").classList.add("hidden");
    let moves = document.querySelectorAll("#p1 .moves button");
    for (let i = 0; i < moves.length; i++) {
      moves[i].toggleAttribute("disabled");
    }
    document.querySelector("h1").textContent = "Pokemon Battle!";
    let gameInfoArray = await initializeGame(pokemonName);
    playGame(gameInfoArray[0], gameInfoArray[1], gameInfoArray[2]);
  }

  /**
   * Retrieves the game ids and sets the hp bars to 100% and green
   * @param {string} name - shortName of the pokemon player 1 is using
   * @returns {array} Array in the form [game id, player id, array of moves that player 1's
   * pokemon knows]
   */
  async function initializeGame(name) {
    let data = new FormData();
    data.append("startgame", "true");
    data.append("mypokemon", name);
    try {
      let res = await fetch(GAME_URL, {method: "POST", body: data});
      await statusCheck(res);
      let gameState = await res.json();
      let idsAndMoves = [gameState.guid, gameState.pid, gameState.p1.moves];
      fillCard(gameState.p2.shortname, "p2");
      document.querySelector("#p1 .health-bar").style.width = "100%";
      document.querySelector("#p1 .health-bar").classList.remove("low-health");
      document.querySelector("#p2 .health-bar").style.width = "100%";
      document.querySelector("#p2 .health-bar").classList.remove("low-health");
      return idsAndMoves;
    } catch (err) {
      console.error(err);
    }
  }

  /**
   * Allows you to play the games by clicking on a button to use that specific move against
   * player 2's pokemon
   * @param {string} guid - unique game id value from the game state
   * @param {string} pid - unique player id value from the game state
   * @param {Array} moveNameArray - Array of moves that player 1's pokemon knows
   */
  function playGame(guid, pid, moveNameArray) {
    let moveButtons = document.querySelectorAll("#p1 .moves button");
    for (let i = 0; i < moveNameArray.length; i++) {
      clearEventListeners(moveButtons[i]);
    }
    moveButtons = document.querySelectorAll("#p1 .moves button");
    for (let i = 0; i < moveNameArray.length; i++) {
      moveButtons[i].addEventListener("click", () => {
        playMove(guid, pid, fixMoveName(moveNameArray[i].name));
      });
    }
    clearEventListeners(document.getElementById("flee-btn"));
    document.getElementById("flee-btn").addEventListener("click", () => {
      playMove(guid, pid, "flee");
    });
  }

  /**
   * Simply removes spaces from the given moveName and makes it lowercase
   * @param {string} moveName - name of the move to be used
   * @returns {string} the moveName string but all lowercase with no spaces
   */
  function fixMoveName(moveName) {
    let names = moveName.split(" ");
    let fixedName = "";
    for (let i = 0; i < names.length; i++) {
      fixedName = fixedName + names[i];
    }
    return fixedName.toLowerCase();
  }

  /**
   * Plays the clicked move against player 2
   * @param {string} guid - game id value from the game state
   * @param {string} pid - player id value from the game state
   * @param {string} moveName - name of the move to be used (assumes no spaces, all lowercase)
   */
  async function playMove(guid, pid, moveName) {
    pendingMove(true);
    let gameData = new FormData();
    gameData.append("guid", guid);
    gameData.append("pid", pid);
    gameData.append("movename", moveName);
    try {
      let res = await fetch(GAME_URL, {method: "POST", body: gameData});
      await statusCheck(res);
      let results = await res.json();
      resolveTurn(results);
    } catch (err) {
      console.error(err);
    }
  }

  /**
   * disables/enables move buttons for player 1 and enables/disables the loading icon
   * @param {boolean} tF -true if the move is in a pending state, false if move has been resolved
   */
  function pendingMove(tF) {
    let moves = document.querySelectorAll("#p1 .moves button");
    for (let i = 0; i < moves.length; i++) {
      moves[i].toggleAttribute("disabled");
    }
    if (tF) {
      document.getElementById("loading").classList.remove("hidden");
    } else {
      document.getElementById("loading").classList.add("hidden");
    }
  }

  /**
   * Resolves the turn and updates the hp information of the player cards accordingly
   * @param {json} result - includes all of the game state information, including:
   * what move was used, if that move hit and current hp values of both pokemon
   */
  function resolveTurn(result) {
    pendingMove(false);
    document.getElementById("p1-turn-results").textContent = "Player 1 played " +
    result.results["p1-move"] + " and " + result.results["p1-result"] + "!";
    if (result.results["p2-move"] !== null) {
      document.getElementById("p2-turn-results").textContent = "Player 2 played " +
      result.results["p2-move"] + " and " + result.results["p2-result"] + "!";
    } else {
      document.getElementById("p2-turn-results").textContent = "";
    }
    if (updateHealth("p1", result.p1["current-hp"], result.p1.hp, result.p1.shortName)) {
      gameEnd(false, result.p2.shortname, result.p1.shortname);
    }
    if (updateHealth("p2", result.p2["current-hp"], result.p2.hp, result.p2.shortName)) {
      gameEnd(true, result.p2.shortname, result.p1.shortname);
    }
  }

  /**
   * Updates the health of the pokemon, adjusting the width of the hp bar and turning it red
   * if health is under CRITICAL_HP
   * @param {string} player - p1 for player 1 and p2 for player 2
   * @param {integer} currentHealth - pokemons current hp
   * @param {integer} maxHealth - pokemons max hp
   * @returns {boolean} true if given player has a pokemon with 0 current HP, false otherwise
   */
  function updateHealth(player, currentHealth, maxHealth) {
    document.querySelector("#" + player + " .hp").textContent = currentHealth + "HP";
    document.querySelector("#" + player + " .health-bar").style.width = (currentHealth /
    maxHealth * 100) + "%";
    if ((currentHealth / maxHealth) <= CRITICAL_HP) {
      document.querySelector("#" + player + " .health-bar").classList.add("low-health");
    } else {
      document.querySelector("#" + player + " .health-bar").classList.remove("low-health");
    }
    if (currentHealth === 0) {
      return true;
    }
    return false;
  }

  /**
   * Disables player 1's moves and triggers a victory if player 1 won and a loss otherwise
   * @param {boolean} winLoss - true if player 1 won, false otherwise
   * @param {string} theirPokemon  - shortName of player 2's pokemon
   * @param {string} ourPokemon - shortName of player 1's pokemon
   */
  function gameEnd(winLoss, theirPokemon, ourPokemon) {
    document.getElementById("flee-btn").classList.add("hidden");
    document.getElementById("endgame").classList.remove("hidden");
    let moves = document.querySelectorAll("#p1 .moves button");
    for (let i = 0; i < moves.length; i++) {
      moves[i].toggleAttribute("disabled");
    }
    if (winLoss) {
      document.querySelector("h1").textContent = "You Won!";
      clearEventListeners(document.getElementById("endgame"));
      document.getElementById("endgame").addEventListener("click", () => {
        wonGame(theirPokemon, ourPokemon);
      });
    } else {
      document.querySelector("h1").textContent = "You Lost!";
      clearEventListeners(document.getElementById("endgame"));
      document.getElementById("endgame").addEventListener("click", () => {
        lostGame(ourPokemon);
      });
    }
  }

  /**
   * Simply ends the game
   * @param {string} ourPokemon -shortName of player 1's pokemon
   */
  function lostGame(ourPokemon) {
    endGame(ourPokemon);
  }

  /**
   * finds player 2's pokemon if not already found, otherwise ends the game
   * @param {string} theirPokemon - shortName of player 2's pokemon
   * @param {string} ourPokemon - shortName of player 1's pokemon
   */
  function wonGame(theirPokemon, ourPokemon) {
    if (!foundPokemon.includes(theirPokemon)) {
      find(theirPokemon);
    }
    endGame(ourPokemon);
  }

  /**
   * ends the game, displaying the pokedex screen again and hiding all of the
   * battle related elements
   * @param {string} ourPokemon - shortName of player 1's last used pokemon
   */
  function endGame(ourPokemon) {
    document.getElementById("pokedex-view").classList.remove("hidden");
    document.getElementById("endgame").classList.add("hidden");
    document.getElementById("results-container").classList.add("hidden");
    document.getElementById("p1-turn-results").textContent = "";
    document.getElementById("p1-turn-results").classList.add("hidden");
    document.getElementById("p2-turn-results").textContent = "";
    document.getElementById("p2-turn-results").classList.add("hidden");
    document.getElementById("p2").classList.add("hidden");
    document.querySelector("#p1 .hp-info").classList.add("hidden");
    document.getElementById("start-btn").classList.remove("hidden");
    document.querySelector("h1").textContent = "Your Pokedex";
    fillCard(ourPokemon, "p1");
  }

  /**
   * Gets rid of any event listeners on an element
   * @param {HTMLElement} button - element that you want no event listeners on
   */
  function clearEventListeners(button) {
    let cleanButton = button.cloneNode(true);
    button.parentElement.replaceChild(cleanButton, button);
  }

})();