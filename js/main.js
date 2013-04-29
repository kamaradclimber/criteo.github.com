var Slideshow = (function (){
	
	var my = {};
	var slidesList = $(".slide");
	var slidesNumber = slidesList.length;
	var index = 0;
	var btnLeft = $("#btnLeft");
	var btnRight = $("#btnRight");
	var offset = "328px";
	var timer;
	
	function init() {
		slidesList.each(function(i) {
			var elt = $(this);
			if(i != index)
				$(this).css('left', offset);
		});
		$(slidesList[index]).css('left', '0');
	}
	
	function clickBtnLeftInit() {
		btnLeft.on('click', function() {
			window.clearInterval(timer);
			if(index > 0) {
				index--;
				$(slidesList[index]).delay(250).animate({left: '0', opacity: 1}, 500);
				$(slidesList[index +1]).animate({left: offset, opacity: 0}, 500);
			} else {
				index = 4;
				$(slidesList[index]).css('left', '-' + offset);
				$(slidesList[index]).delay(250).animate({left: '0', opacity: 1}, 500);
				$(slidesList[0]).animate({left: offset, opacity: 0}, 500, function() {
					//animation complete
					var i;
					for(i=0; i < slidesNumber - 1; i++) {
						$(slidesList[i]).css('left', '-' + offset);
					}
				});
			}
			setTimeout(function(){ launchTimer(); },2000);
			
		});
	}
	
	
	function clickBtnRightInit() {
		btnRight.on('click', function() {
			window.clearInterval(timer);
			rotateRight();
			setTimeout(function(){ launchTimer(); },2000);
			
		});
	}
	
	function rotateRight() {
		if(index < slidesNumber - 1) {
			index++;
			$(slidesList[index - 1]).animate({left: "-" + offset, opacity: 0}, 500);
			$(slidesList[index]).delay(250).animate({left: '0px', opacity: 1}, 500);
		}
		else {
			index = 0;
			$(slidesList[index]).css('left', offset);
			$(slidesList[index]).delay(250).animate({left: '0', opacity: 1}, 500);
			$(slidesList[slidesNumber - 1]).animate({left: '-' + offset, opacity: 0}, 500, function() {
				//animation complete
				var i;
				for(i=1; i < slidesNumber; i++) {
					$(slidesList[i]).css('left', offset);
				}
			});
		}
	}
	
	function launchTimer() {
		timer=setInterval(function(){rotateRight(); }, 2500);
	}
	
	my.launch = function() {
		init();
		clickBtnLeftInit();
		clickBtnRightInit();
		launchTimer();
	}
	
	return my;
}());

$(document).ready(function() {
	Slideshow.launch();
	
	//fix projectDetails height;
	var height = 0;
	$('.projectType').each(function() {
		if(this.offsetHeight > height)
			height = this.offsetHeight;
	});
	$('#projectDetails').css('height', height + 10 + 'px');
	
});
