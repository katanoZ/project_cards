window.addEventListener('DOMContentLoaded', setMyPageFileName);

//ファイル選択時に、ファイル選択ボタンにファイル名を表示
function setMyPageFileName(){
  const myPageFileField = document.querySelector('#js-mypage_filefield');
  if (myPageFileField === null) { return; }

  myPageFileField.addEventListener('change', () => {
    const inputFileName = document.querySelector('#js-mypage_filefield').files[0].name;
    const fileNameText = document.querySelector('#js-mypage_filename_text');
    fileNameText.textContent = inputFileName;
  });
};
