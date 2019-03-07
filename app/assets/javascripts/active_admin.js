//= require active_admin/base

//= require froala_editor.pkgd.min.js
//= require plugins/image.min.js

// $(function() {
//     $('#myEditor').froalaEditor({
//         // Set the save param.
//         saveParam: 'content',

//         // Set the save URL.
//         saveURL: 'edit/save',

//         // HTTP request type.
//         saveMethod: 'POST',

//         // Additional save params.
//         saveParams: {id: 'my_editor'},

//         // Route for uploading images
//         imageUploadURL: 'edit/upload_image'
//     });

//     $('#myEditor').froalaEditor('html.set', "<%= page.pending_content %>");

//     // .on('froalaEditor.save.before', function (e, editor) {
//     //     // Before save request is made.
//     // })
//     // .on('froalaEditor.save.after', function (e, editor, response) {
//     //     // After successfully save request.
//     // })
//     // .on('froalaEditor.save.error', function (e, editor, error) {
//     //     // Do something here.
//     // })

//     // .on('froalaEditor.image.removed', function (e, editor, $img) {
//     //     $.ajax({
//     //         // Request method.
//     //         method: "DELETE",

//     //         // Request URL.
//     //         url: "edit/delete_image",

//     //         // Request params.
//     //         data: {
//     //             src: $img.attr('src')
//     //         }
//     //     })
//     // })
//     // .done (function (data) {
//     //     console.log ('image was deleted');
//     // })
//     // .fail (function () {
//     //     console.log ('image delete problem');
//     // })
// });

// $('#saveButton').click (function () {
//     $('#myEditor').froalaEditor('save.save')
// });