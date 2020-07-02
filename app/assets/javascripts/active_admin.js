//= require active_admin/base
//= require activeadmin/quill_editor/quill
//= require activeadmin/quill_editor_input


/* Ovveride Quill editor toolbar */
window.onload = function() {
    initQuillEditors();
}

$(document).on('has_many_add:after', function() {
    initQuillEditors();
});

var initQuillEditors = function() {
    var editors = document.querySelectorAll('.quill-editor');
    var default_options = {
        modules: {
            toolbar: [
                [{ header: [1, 2, 3, 4, 5, false] }],
                ['bold', 'italic', 'underline'],
                ['link', 'blockquote', 'code-block'],
                [{ 'align': [] }, { list: 'ordered' }, { list: 'bullet' }],
                [{ 'color': [] }, { 'background': [] }],
            ]
        },
        placeholder: '',
        theme: 'snow'
    };

    for(var i = 0; i < editors.length; i++) {
        var content = editors[i].querySelector('.quill-editor-content');
        var isActive = editors[i].classList.contains('quill-editor--active');
        if(content && !isActive) {
            var options = editors[i].getAttribute('data-options') ? JSON.parse(editors[i].getAttribute('data-options')) : default_options;
            editors[i]['_quill-editor'] = new Quill(content, options);
            editors[i].classList += ' quill-editor--active';
        }
    }

    var formtastic = document.querySelector('form.formtastic');
    if(formtastic) {
        formtastic.onsubmit = function() {
            for(var i = 0; i < editors.length; i++) {
                var input = editors[i].querySelector('input[type="hidden"]');
                input.value = editors[i]['_quill-editor'].root.innerHTML;
            }
        };
    }
};
