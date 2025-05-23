/*  Avery Colley
 *  Section AC
 *
 *  Sets up the Yipper website using the yipper API, displays yips made by users
 *  and allows users to "like" yips made by other users.
 */

"use strict";

(function() {
  window.addEventListener("load", init);

  const YIPPER_URL = "http://localhost:8000/yipper";

  function init() {
    fillYips();
    activateHomeButton();
  }

  /**
   * Creates the yips and places them onto the page
   */
  async function fillYips() {
    try {
      let yips = await fetch(YIPPER_URL + "/yips");
      await statusCheck(yips);
      yips = await yips.json();
      yips = yips.yips;
      let home = document.getElementById("home");
      for (let i = 0; i < yips.length; i++) {
        let yipCard = document.createElement("article");
        yipCard.classList.add("card");
        yipCard.id = yips[i].id;
        home.appendChild(yipCard);
        let pfp = document.createElement("img");
        let yipDiv = document.createElement("div");
        let yipLikes = document.createElement("div");
        yipLikesHandler(yipLikes, yips[i].date, yips[i].likes);
        yipDivHandler(yipDiv, yips[i].name, yips[i].yip, yips[i].hashtag);
        pfp.src = "/img/" + splitTheName(yips[i].name) + ".png";
        yipCard.appendChild(pfp);
        yipCard.appendChild(yipDiv);
        yipCard.appendChild(yipLikes);
      }
    } catch (err) {
      error();
    }
  }

  /**
   * Given a node, fills that node with the full "yip" and the name of the user who wrote it
   * @param {Node} yipDiv - The node that contains the text for the "yip" and its corresponding #
   * @param {String} name - The name of the user who made the "yip"
   * @param {String} yip - The text of the "yip" can contain any whitespace or
   * word character ( a-z.?!_)
   * @param {String} hashtag - The text following the # on the "yip", contains no spaces
   */
  function yipDivHandler(yipDiv, name, yip, hashtag) {
    let yipName = document.createElement("p");
    yipName.textContent = name;
    yipName.classList.add("individual");
    let yipText = document.createElement("p");
    yipText.textContent = yip + " #" + hashtag;
    yipDiv.appendChild(yipName);
    yipDiv.appendChild(yipText);
    yipName.addEventListener("click", () => {
      clickedUser(yipName);
    });
  }

  async function clickedUser(initialElement) {
    document.getElementById("home").classList.add("hidden");
    document.getElementById("new").classList.add("hidden");
    document.getElementById("user").innerHTML = "";
    try {
      let userYips = await fetch(YIPPER_URL + "/user/:" + initialElement.textContent);
      await statusCheck(userYips);
      userYips = userYips.json();
    } catch (err) {
      error();
    }
  }

  /**
   * Adds the heart icon and the number of likes a "yip" has to the container that
   * holds that information
   * @param {Node} yipLikes - Node containing the amount of likes a "yip" has
   * @param {Integer} date - Date the "yip" was submitted
   * @param {Integer} likes - Amount of likes the "yip" has
   */
  function yipLikesHandler(yipLikes, date, likes) {
    yipLikes.classList.add("meta");
    let yipDate = document.createElement("p");
    yipDate.textContent = (new Date(date)).toLocaleString();
    let yipLikeCountContainer = document.createElement("div");
    let yipHearts = document.createElement("img");
    yipHearts.src = "/img/heart.png";
    yipHearts.addEventListener("click", () => {
      clickToLike(yipHearts);
    });
    let yipLikeCount = document.createElement("p");
    yipLikeCount.textContent = likes;
    yipLikeCountContainer.appendChild(yipHearts);
    yipLikeCountContainer.appendChild(yipLikeCount);
    yipLikes.appendChild(yipDate);
    yipLikes.appendChild(yipLikeCountContainer);
  }

  /**
   * Adds the ability to click on the heart in order to increment the amount of likes a "yip" has
   * by one
   * @param {Node} initalElement - Element that contains the heart icon
   */
  async function clickToLike(initalElement) {
    let yipCard = initalElement.parentNode.parentNode.parentNode;
    let data = new FormData();
    data.append("id", yipCard.id);
    try {
      let res = await fetch(YIPPER_URL + "/likes", {method: "POST", body: data});
      await statusCheck(res);
      let likeCount = await res.text();
      initalElement.nextElementSibling.textContent = likeCount;
    } catch (err) {
      error();
    }
  }

  /**
   * Takes in a string and makes it all lower case and replaces any spaces with hyphens
   * @param {String} name - Name you want to split
   * @returns {String} The string "name" after turning it to all lower case and replacing the
   * spaces with hyphens
   */
  function splitTheName(name) {
    name = name.toLowerCase();
    let nameArray = name.split(" ");
    let splitName = nameArray[0];
    for (let i = 1; i < nameArray.length; i++) {
      splitName = splitName + "-" + nameArray[i];
    }
    return splitName;
  }

  /**
   * Adds the ability to click on the home button in order to return to the home page
   */
  function activateHomeButton() {
    document.getElementById("home-btn").addEventListener("click", () => {
      document.getElementById("user").classList.add("hidden");
      document.getElementById("new").classList.add("hidden");
      document.getElementById("home").classList.remove("hidden");
      document.getElementById("search-term").textContent = "";
    });
  }

  /**
   * Called when an error happens, hides everything important, disables all buttons and shows the
   * error message
   */
  function error() {
    document.getElementById("yipper-data").classList.add("hidden");
    document.getElementById("error").classList.remove("hidden");
    let buttons = document.querySelectorAll("nav button");
    for (let i = 0; i < buttons.length; i++) {
      buttons[i].disabled = true;
    }
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
})();