(function($) {
  $.fn.caretRange = function(posStart, posEnd) {
    var target = this[0];
    var isContentEditable = target.contentEditable === 'true';
    //get
    if (arguments.length == 0) {
      //HTML5
      if (window.getSelection) {
        //contenteditable
        if (isContentEditable) {
          target.focus();
          var range1 = window.getSelection().getRangeAt(0),
              range2 = range1.cloneRange();
          range2.selectNodeContents(target);
          range2.setEnd(range1.endContainer, range1.endOffset);
          return range2.toString().length;
        }
        //textarea
        return {
          start: target.selectionStart,
          end: target.selectionEnd
        };
      }
      //IE<9
      if (document.selection) {
        target.focus();
        //contenteditable
        if (isContentEditable) {
            var range1 = document.selection.createRange(),
                range2 = document.body.createTextRange();
            range2.moveToElementText(target);
            range2.setEndPoint('EndToEnd', range1);
            return range2.text.length;
        }
        //textarea
        var posStart = 0,
          posEnd = (target.value || target.innerText).length,
          range = target.createTextRange(),
          range2 = document.selection.createRange().duplicate(),
          bookmark = range2.getBookmark();
        range.moveToBookmark(bookmark);
        while (range.moveStart('character', -1) !== 0) posStart++;
        while (range.moveEnd('character', 1) !== 0) posEnd--;
        return {
          start: posStart,
          end: posEnd
        };
      }
      //not supported
      return {
        start: 0,
        end: 0
      };
    }
    //set
    //if (target.nodeName.toLowerCase() !== "input") return 0;
    if (posStart == -1)
      posStart = this[isContentEditable? 'text' : 'val']().length;
    //HTML5
    if (window.getSelection) {
      //contenteditable
      if (isContentEditable) {
        target.focus();
        window.getSelection().collapse(target.firstChild, posStart);
      }
      //textarea
      else
        target.setSelectionRange(posStart, posEnd);
    }
    //IE<9
    else if (document.body.createTextRange) {
      //See http://stackoverflow.com/questions/3274843/get-caret-position-in-textarea-ie
      var range = target.createTextRange();
      var startCharMove = posStart - (target.value.slice(0, posStart).split("\r\n").length - 1);
      range.collapse(true);
      if (posStart == posEnd) {
        range.move("character", startCharMove);
      } else {
        range.moveEnd("character", offsetToRangeCharacterMove(el, posEnd));
        range.moveStart("character", startCharMove);
      }
      range.select();
      return {
        start: 0,
        end: 0
      };
    }
    if (!isContentEditable)
      target.focus();
    return {
      start: posStart,
      end: posEnd
    };
  }
  $.fn.caret = function (pos){
    var target = this;
    if (arguments.length == 0) {
      var ret = target.caretRange();
      return ret.start;
    } else {
      var ret = target.caretRange(pos, pos);
      return ret.start;
    }
  }
})(jQuery)