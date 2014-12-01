
module.exports =
  id: 'wellcome'
  background: 'background.jpg'

  producer: 'Wellcome Library & Zooniverse'
  title: 'Industry and Illness'
  summary: 'Mapping work and public health in the London MOH reports'
  description: 'Short description'

  pages: [{
    'About': '''
      <h2>All about the project</h2>
      <p>This is where we\'ll go into detail.</p>
      <hr />
      <h3>Lorem ipsum dolor sir amet.</h3>
      <p>Break it into sections, add pictures, whatever.</p>
    '''
  }]
  
  tasks:
    illustrations:
      type: 'radio'
      question: 'Are there any illustrations on this page?'
      choices: [{
        label: 'Yes'
        value: 'yes'
        next: 'review'
      },{
        label: 'No'
        value: 'no'
      }]
    review:
      type: 'button'
      question: "Use the 'Back' button to review your work, or click 'Finished' to move on to the next page."
      choices: [{
        label: 'Finished'
        next: null
      }]

  firstTask: 'illustrations'

