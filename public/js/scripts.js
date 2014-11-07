//Global Variables

function evaluateLetterGuess(letterGuess){
	$.ajax({
		method: 'POST',
		url: '/hangman/' + $id + '/guess',
		dataType: 'JSON',
		data: {letterGuess: letterGuess},
		success: handleServerResponse
	});
}

function evaluateWordGuess(wordGuess){
	$.ajax({
		method: 'POST',
		url: '/hangman/' + $id + '/word',
		dataType: 'JSON',
		data: {wordGuess: wordGuess},
		success: handleServerResponse
	});
}

function updateHiddenWordDisplay(currentGuessStatus) {
		$secretWordDisplay.text(currentGuessStatus);
	}

function handleServerResponse(data) {  
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
	$.ajax({
		method: 'GET',
		url: '/ttt/search_users',
		dataType: 'JSON',
		data:{query: query},
		success: function(data){
			console.log(data);
			var $usersList = $('ul.user-matches');

			$usersList.empty();

			data.forEach(function(user){
				var $userNode = $('<li>').text(user.username + ' ('+user.email+')');
				$usersList.append($userNode);
			});
		}
	});
}


