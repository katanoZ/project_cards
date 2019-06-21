window.addEventListener('DOMContentLoaded', setFileName);

//ファイル選択時に、ファイル選択ボタンにファイル名を表示
function setFileName(){
  const fileField = document.getElementById('js-filefield');

  fileField.addEventListener('change', () => {
    const newFileNameText = document.getElementById('js-filefield').files[0].name;
    const fileName = document.getElementById('js-filename');
    fileName.textContent = newFileNameText;
  });
};
