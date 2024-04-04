function toggleInstructors() {
    var seeAllInstructors = document.querySelector('.see-all-instructors');
    var toggleButton = document.getElementById('toggle-button');
  
    if (seeAllInstructors.style.display === 'none') {
      seeAllInstructors.style.display = 'list-item';
      toggleButton.innerHTML = 'Show Less';
    } else {
      seeAllInstructors.style.display = 'none';
      toggleButton.innerHTML = 'Show More';
    }
  }