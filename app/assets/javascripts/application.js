// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery_nested_form
//= require jquery.ui.all
//= require_tree .

// Flash fade
	$(function() {
	   $('.alert-success').fadeIn('normal', function() {
	      $(this).delay(3700).fadeOut();
	   });
	});
	
	$(function() {
	   $('.alert-error').fadeIn('normal', function() {
	      $(this).delay(3700).fadeOut();
	   });
	});

// Datepicker code
	$(function() {
		$(".datepicker").datepicker({
			format: 'mm/dd/YYYY'
		});
	});

// Autosubmit the quick registration form on the sections#show view
	$(function() {
		$('#registration_student_id').change(function()
		 {
		     $('#new_registration').submit();
		 });
	});

// Autosubmit the quick dojo registration form on the dojo#show view
	$(function() {
		$('#dojo_student_student_id').change(function()
		 {
		     $('#new_dojo_student').submit();
		 });
	});
	