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
		var acceptedInvites = data.accepted_invites;
		openInvitesToHTML(openInvites);
		acceptedInvitesToHTML(acceptedInvites);
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

	function acceptedInvitesToHTML(invites){
		var $openGameList = $('ul.current-games');
		$openGameList.empty();
		invites.forEach(function(invite){
			var $openGameNode = $('<li>').text('Open Tic Tac Toe Game- Challenger: ' + invite.sender.username + ', Against: ' + invite.recipient.username + '. Started on ' + invite.updated_at);
			var $linkToGame = $('<a>');
			$linkToGame.text('Play Game');
			$linkToGame.attr("href", '/ttt/' + invite.ttt_game.id);
			$openGameNode.append($linkToGame);
			$openGameList.append($openGameNode);
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
	var $id = $('h1').data('id');
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

function renderCurrentBoard(){
	var $id = $('h1').data('id');
	$.ajax({
		method: 'GET',
		url: '/ttt/' + $id + '/render_board',
		dataType: 'json',
		success: renderTttBoard
	});

	function renderTttBoard(data){
		console.log(data);
		var $movesArray = data.moves_array;
		var $whosTurn = data.current_turn.username;
		updateTttBoard($movesArray);
		updateWhosTurn($whosTurn);
	}

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

	setTimeout(function(){
		renderCurrentBoard();
	}, 1000);
}




