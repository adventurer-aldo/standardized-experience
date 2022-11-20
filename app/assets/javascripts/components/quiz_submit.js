function submitNames(event) {
  event.preventDefault();
  document.getElementById('submitBtn').disabled = true;
  var first_name = document.getElementById('first_name').value;
  var last_name = document.getElementById('last_name').value;
  document.getElementById('name_first').value = first_name;
  document.getElementById('name_last').value = last_name;
  form = document.getElementById('quiz');
  formWithData = new FormData(form);
  axios.post('/quiz', formWithData).then(() => {
    window.location = `/results/${form.elements['quizID'].value}`
  })
}