require './readymade/overrides.coffee'

currentProject = require 'zooniverse-readymade/current-project'
classify_page = currentProject.classifyPages[0]

{decisionTree, subjectViewer} = classify_page
  
ms = subjectViewer.markingSurface

current_task = null

class TextViewer
  
  constructor: ->
    @el = document.createElement "pre"
    @el.style.display = "inline-block"
    @el.style.textAlign = "left"
    @el.style.marginLeft = ".5em"
    
    @el.addEventListener 'mouseup', (e) =>
      @createAnnotation()
  
  createAnnotation: =>
    at = new AnnotationTool @el, window.getSelection(), current_task.getChoice().color
    console.log at.annotation
  
  load: (text) =>
    @el.innerHTML = text

class AnnotationTool
  
  constructor: (@text, sel, type) ->
    return unless sel.type is 'Range'
    @el = document.createElement 'b'
    @el.setAttribute 'tabindex', 0
    @wrapHTML sel
  
    @el.addEventListener 'click', (e) =>
      return unless @el.parentNode == @text
      e.preventDefault()
      @unwrapHTML()
    @el.addEventListener 'mouseup', (e) =>
      e.stopPropagation()
    
    @el.style.backgroundColor = type
    @el.style.color = '#333'
  
    {start, end} = @getNodePosition()
    @annotation = 
      text: @el.textContent
      start: start
      end: end
      node: @el
    
  wrapHTML: (sel) =>
    range = sel.getRangeAt 0 if sel.rangeCount
    range = range.cloneRange()
    range.surroundContents @el
    sel.removeAllRanges()
    sel.addRange range
  
  unwrapHTML: () =>
    text = @el.textContent
    @el.insertAdjacentHTML 'afterend', text
    @text.removeChild @el
    @text.normalize()
  
  getNodePosition: () =>
    start = 0
    for node in @text.childNodes
      if node == @el
        break
      else
        start += node.textContent.length
  
    end = start + node.textContent.length
    start += 1
    {start, end}

text_viewer = new TextViewer
subjectViewer.markingSurfaceContainer.append text_viewer.el

# set the image scale if not already set  
ms.on 'marking-surface:add-tool', (tool) ->
  @rescale() if @scaleX is 0

classify_page.on classify_page.LOAD_SUBJECT, (e, subject)->
  ms.maxWidth = subjectViewer.maxWidth
  ms.maxHeight = subjectViewer.maxHeight
  ms.rescale 0, 0, subjectViewer.maxWidth, subjectViewer.maxHeight
  
  $.get( subject.location.ocr ).done (response) ->
    text_viewer.load response

classify_page.el.on decisionTree.LOAD_TASK, ({originalEvent: detail: {task}})->
  current_task = task