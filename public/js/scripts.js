//Global Variables

function evaluateLetterGuess(letterGuess){

	function updateHiddenWordDisplay(currentGuessStatus) {
		$secretWordDisplay.text(currentGuessStatus);
	}

	function handleServerResponse(data) {  //if you get back any data?
		console.log(data);
		var correctLetters = data.correct_letters;
		var incorrectLetters = data.incorrect_letters;

		updateHiddenWordDisplay(data.secret_word);
		displayCorrectGuesses(correctLetters);
		displayIncorrectGuesses(incorrectLetters);
		//want to change h3#live-score
		$scoreDisplay.text(data.score);

	}

	$.ajax({
		method: 'POST',
		url: '/hangman/' + $id + '/guess',
		dataType: 'JSON',
		data: {letterGuess: letterGuess},
		success: handleServerResponse
		//figure out how to use ajax error
	});
}

function evaluateWordGuess(word){

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
		$list.append(letterHTML);
	});
}

function letterToHTML(letter){
	$li = $("<li>");
	return $li.text(letter);
}
