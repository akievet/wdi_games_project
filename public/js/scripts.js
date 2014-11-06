//Global Variables

function evaluateLetterGuess(letter){


	$.ajax({
		method: 'POST'
		url: '/hangman/' + $id + '/guess',
		dataType: 'JSON',
		data: {letterGuess: letterGuess},
		success: function(data){ //if you get back any data?
			console.log(data);
			var correctLetters = data.correct_letters;
			var incorrectLetters = data.incorrect_letters;
			
			
			//want to change the text of h1#blanks to the new blanks value
			$secretWordDisplay.text(data.secret_word); 
			//want to create a new ul#correct-guesses to reflect eval
			displayCorrectGuesses(correctLetters);
			//want to create a new ul#incorrect-guesses to reflect eval 
			displayIncorrectGuesses(incorrectLetters);
			//want to change h3#live-score
			$scoreDisplay.text(data.score);
		};
		//figure out how to use ajax error
	});
}

function evaluateWordGuess(word){

}

function displayCorrectGuesses(letterArray){
	$correctGuessesUl.empty();
	$(letterArray).each(function(idx, letter){
		var letterHTML = letterToHTML(letter);
		$correctGuessesUl.append(letterHTML);
	})
}

function displayIncorrectGuesses(letterArray){
	$incorrectGuessesUl.empty();
	$(letterArray).each(function(idx, letter){
		var letterHTML = letterToHTML(letter);
		$incorrectGuessesUl.append(letterHTML);
	})
}

function letterToHTML(letter){
	$li = $("<li>");
	$li.text(letter);
}


//jQuery Document Ready
$(function(){
	//Document Variables
	$id = $('h5').data('id')
	$secretWordDisplay = $('h1#blanks');
	$correctGuessesUl = $('ul#correct-guesses');
	$incorrectGuessesUl = $('ul#incorrect-guesses');
	$scoreDisplay = $('h3.live-score');

	$('form.guess-letter').on('submit', function(e){
		e.preventDefault();
		var letterGuess= $('form.guess-letter input[type=text]').val();
		evaluateLetterGuess(letterGuess);
	});

	$('form.guess-word').on('submit', function(e){
		e.preventDefault();
		var wordGuess= $('form.guess-word input[type=text]').val();
		evaluateWordGuess(wordGuess);
	});
})