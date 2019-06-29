'use strict';

BuybidAdmin.Utils.can_advanced_upload = (function() {
  const div = document.createElement('div');
  return (('draggable' in div) || ('ondragstart' in div && 'ondrop' in div)) && 'FormData' in window && 'FileReader' in window;
})();

BuybidAdmin.Utils.register_drag_drop_images = function (box, showFiles, valid_files) {
	const input = box.querySelector('.files_input');

	input.addEventListener('change', function(e) {
		let files = e.target.files;

		if (valid_files(files)) {
	  	showFiles(files);
		} else {
			input.value = '';
			showFiles([]);
		}
	});

	if (BuybidAdmin.Utils.can_advanced_upload) {
		box.classList.add('has-advanced-upload');

		['drag', 'dragstart', 'dragend', 'dragover', 'dragenter', 'dragleave', 'drop'].forEach(function(event) {
	    box.addEventListener(event, function(e) {
	      e.preventDefault();
	      e.stopPropagation();
	    });
		});

		['dragover', 'dragenter'].forEach(function(event) {
	    box.addEventListener(event, function() {
	      box.classList.add('is-dragover');
	    });
		});

		['dragleave', 'dragend', 'drop'].forEach(function(event) {
	    box.addEventListener(event, function() {
	      box.classList.remove('is-dragover');
	    });
		});

		box.addEventListener('drop', function(e) {
			let files = e.dataTransfer.files;

			if (valid_files(files)) {
			  input.files = files;
			  showFiles(files);
			}
		});
	}

	// Firefox focus bug fix for file input
	input.addEventListener('focus', function() {
		input.classList.add('has-focus');
	});
	input.addEventListener('blur', function() {
		input.classList.remove('has-focus');
	});
}
