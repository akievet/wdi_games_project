//Global Variables

function evaluateLetterGuess(letterGuess){
	$.ajax({
		method: 'POST',
		url: '/hangman/' + $id + '/guess',
		dataType: 'JSON',
		data: {letterGuess: letterGuess},
		success: handleServerResponseFromHangmanGame
	});
}

function evaluateWordGuess(wordGuess){
	$.ajax({
		method: 'POST',
		url: '/hangman/' + $id + '/word',
		dataType: 'JSON',
		data: {wordGuess: wordGuess},
		success: handleServerResponseFromHangmanGame
	});
}

function updateHiddenWordDisplay(currentGuessStatus) {
		$secretWordDisplay.text(currentGuessStatus);
	}

function handleServerResponseFromHangmanGame(data) {  
	console.log(data);
	if(data.win){
		var score = data.score;
		handleWinServerResponse(score);
	}else if(data.lose){
		var revealedWord = data.revealed_word;
		handleLoseServerResponse(revealedWord);
	}else{
		var correctLetters = data.correct_letters;
		var incorrectLetters = data.incorrect_letters;

		updateHiddenWordDisplay(data.secret_word);
		displayCorrectGuesses(correctLetters);
		displayIncorrectGuesses(incorrectLetters);
		$scoreDisplay.text(data.score);
	};
}

function displayCorrectGuesses(letterArray){
	updateLetterList(letterArray, $correctGuessesList);
}

function displayIncorrectGuesses(letterArray){
	updateLetterList(letterArray, $incorrectGuessesList);
}

function updateLetterList(letters, list) {
	list.empty();
	$.each(letters, function(idx, letter){
		var letterHTML = letterToHTML(letter);
		list.append(letterHTML);
	});
}

function letterToHTML(letter){
	$li = $("<li>");
	return $li.text(letter);
}

function handleWinServerResponse(score){
	window.alert("You won! Score: " + score);
}

function handleLoseServerResponse(word){
	window.alert("You lose :( Word: " + word);
}



function searchForUser(query){
	function handleServerResponseFromUserSearch(data){
		console.log(data);

		var $usersList = $('ul.user-matches');
		$usersList.empty();

		data.forEach(function(user){
			var $userNode = $('<li>').text(user.username + ' ('+user.email+')');
			var $inviteButton = $('<button>').text('Invite to Play');
			$inviteButton.on("click", function(e){
				$.ajax({
					url: '/ttt/invite',
					method: 'POST',
					dataType: 'json',
					data: {id: user.id},
					success: function(data){
						console.log(data);
						window.alert("Your invite has been sent to "+ data.name);
					}
				});
			});
			$userNode.append($inviteButton);
			$usersList.append($userNode);
			return $usersList;
		});
	}


	$.ajax({
		method: 'GET',
		url: '/ttt/search_users',
		dataType: 'JSON',
		data:{query: query},
		success: handleServerResponseFromUserSearch
	});
}

// // // // FOR GETTING MESSAGES ON INDEX PAGE // // // // 

function getMessages(){

	function handleInvitesData(data){
		console.log(data);
		var openInvites = data.open_invites;
		var openHMGames = data.open_hm_games;
		var openTTTGames = data.open_ttt_games;

		openInvitesToHTML(openInvites);
		openGamesToHTML(openHMGames, openTTTGames);
	}

	function openGamesToHTML(hmGames, tttGames){
		var $openHMGameList = $('ul.current-hm-games');
		var $openTTTGameList = $('ul.current-ttt-games');
		$openHMGameList.empty();
		$openTTTGameList.empty();

		hmGames.forEach(function(game){
			var $openHMGameNode = $('<li>').text('Open Hangman Game. Last Played: ' + game.updated_at + '.');
			var $linkToHMGame = $('<a>');
			$linkToHMGame.text('Play Game');
			$linkToHMGame.attr('href', '/hangman/' + game.id);
			$openHMGameNode.append($linkToHMGame);
			$openHMGameList.append($openHMGameNode);
		});

		tttGames.forEach(function(game){
			var $openTTTGameNode = $('<li>').text('Open Tic Tac Toe Game. ' + game.player_1.username + ' against ' + game.player_2.username + '. Last Played: ' + game.updated_at + '.');
			var $linkToTTTGame = $('<a>');
			$linkToTTTGame.text('Play Game');
			$linkToTTTGame.attr('href', '/ttt/' + game.id);
			$openTTTGameNode.append($linkToTTTGame);
			$openTTTGameList.append($openTTTGameNode);
		});
	}

	function openInvitesToHTML(invites){
		var $invitesList = $('ul.invites');
		$invitesList.empty();
		invites.forEach(function(invite){
			var $inviteNode = $('<li>').text('From: '+invite.sender.username + ' ('+invite.created_at+')\n'+invite.message);
			var $initiateGameForm = $("<form/>", {
				action: '/ttt/new',
				method: 'POST'
			}).append(
			$("<input/>",{
				type: 'hidden',
				name: 'id',
				value: invite.id
			}),
			$("<input/>", {
				type: 'submit',
				value: 'Start Game'
			})
			);
			$inviteNode.append($initiateGameForm);
			$invitesList.append($inviteNode);
			return $invitesList;
		});
	}

	$.ajax({
		url: '/invites',
		method: 'GET',
		dataType: 'json',
		success: handleInvitesData
	});

	setTimeout(function(){
		getMessages();
	}, 3000);
}

// // // // FOR TIC TAC TOE SHOW PAGE // // // // 

function makeMove(spaceId){
	var $id = $('h1#game_id').data('id');
		$.ajax({
		method: 'POST',
		url: '/ttt/' + $id + '/move',
		dataType: 'json',
		data: {
			spaceId: spaceId 
		},
		success: function(data){
			console.log(data);
		}
	});
}

function getCurrentGameState(){
	var $id = $('h1#game_id').data('id');
	$.ajax({
		method: 'GET',
		url: '/ttt/' + $id + '/render_board',
		dataType: 'json',
		success: renderBoardOrEnd
	});

	function renderBoardOrEnd(data){
		console.log(data);
		var $movesArray = data.moves_array;
		if(data.win){
			clearTimeout(intervalController);
			var $winner = data.winner;
			loadPopupBox($winner);
			updateTttBoardAtWin($movesArray);
		}else{
			var $whosTurn = data.current_turn.username;
			renderBoard($movesArray, $whosTurn);
		};
	}

	var intervalController;

	intervalController = setTimeout(function(){
		getCurrentGameState();
	}, 1000);
	
}

function renderBoard(allMoves, username){
	updateTttBoard(allMoves);
	updateWhosTurn(username);

	function updateTttBoard(allMoves){
		allMoves.forEach(function(value){
			var $letter = value[0]
			var $space = value[1]
			$('div#' + $space ).text($letter);
		});
	}

	function updateWhosTurn(username){
		$('h4.current-player').text(username);
	}
}

function updateTttBoardAtWin(allMoves){
	allMoves.forEach(function(value){
		var $letter = value[0]
		var $space = value[1]
		$('div#' + $space ).text($letter);
	});
}

function loadPopupBox(winner){
	$('#popup_box').fadeIn("slow");
	$('#show_page_container').css({
		"opacity":"0.3"
	});
	$('h1.winner').text('Winner: ' + winner.username + '!');
}


function unloadPopupBox(){
	$('#popup_box').fadeOut("slow");
	$('#show_page_container').css({
		'opacity':'1'
	});
	redirectToLeaderBoard();
}


function getScores(){
	var $id = $('h1.user_id').data('id');
	$.ajax({
		method: 'GET',
		url: '/users/' + $id + '/scores',
		dataType: 'json',
		success: renderScores
	});

	function renderScores(data){
		console.log(data);
		debugger
		var $hmGames = data.hangman_games;
		var $tttGames = data.ttt_games;
		renderHMScores($hmGames);
		renderTTTScores($tttGames);

		function renderHMScores(games){
			$hmScoresList = $('ul.hm');
			$hmScoresList.empty();
			games.forEach(function(game){
				var $hmScoreNode = $('<li>').text('Score: '+ game.lives + ' ('+ game.updated_at + ').');
				$hmScoresList.append($hmScoreNode);
			});
		}

		function renderTTTScores(games){
			$tttScoresList = $('ul.ttt');
			$tttScoresList.empty();
			games.forEach(function(game){
				var $tttScoreNode = $('<li>').text('Winner: '+ game.winner.username + ', Loser: ' + game.loser.username + ' (' + game.updated_at + ').');
				$tttScoresList.append($tttScoreNode);
			});
		}
	}
}


