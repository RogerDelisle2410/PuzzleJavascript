<!DOCTYPE html>
<style type="text/css">
    html > body .grad1 {

        background: cyan; /* For browsers that do not support gradients */
        background: -webkit-linear-gradient(cyan, lightblue); /* For Safari 5.1 to 6.0 */
        background: -o-linear-gradient(cyan, lightblue); /* For Opera 11.1 to 12.0 */
        background: -moz-linear-gradient(cyan, lightblue); /* For Firefox 3.6 to 15 */
        background: linear-gradient(cyan, lightblue); /* Standard syntax (must be last ) */
    }

    .normal {
        -ms-transform: rotate(0);
        -webkit-transform: rotate(0deg);
        transform: rotate(0deg);
    }

    img {
        max-width: 100% !important;
        height: auto;
        display: block;
        float: left;
        width: 20%;
    }

    body {
        max-width: 1050px;
        max-height: 900px;
    }

    button {
        height: 22px;
        text-align: center;
    }

    .arrowAlign {
        float: left;
        margin-left: -90px;
    }

    .perspective {
        transform: perspective( 500px ) rotateY( 160deg );
        position: absolute;
        opacity: .6;
        margin-left: -35px;
        width: auto;
        height: auto;
        top: -35px;
    }

    .imgContainer {
        float: left;
    }

    #myAnimation {
        width: 84px;
        height: 59px;
        position: absolute;
        background-color: red;
    }

    div.ImageFront4b {
        content: url("Images/Coke-1-0.png");
    }

    .arrow {
        position: absolute;
        display: inline-block;
    }

    #ImageFrontContainer {
        margin-top: 30px;
    }
</style>
<div id="canvas" style="position: relative"></div>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/5.1.3/css/bootstrap.min.css">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/5.1.3/js/bootstrap.min.js"></script>

<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />
    <link href="Content/bootstrap.css" rel="stylesheet" />
    <title>Puzzle in JavaScript</title>
</head>

<script type="text/javascript">
    /*var oldCan = "Coke";*/
    var oldCan = "Coke";
    var saveNewCan;
    var pBoxDisplayId;
    var pBoxNewCanId;
    var cid = 1;
    var cidImage = 1;
    var image;
    var image0;
    var image1;
    var image2;
    var image3;
    var image4;
    var image5;
    var verifyResult = 0;
    var theBox = 0;
    var theDirection;

    var buttonRight1Style;
    var buttonLeft1Style;
    var buttonRight2Style;
    var buttonLeft2Style;
    var buttonRight3Style;
    var buttonLeft3Style;
    var buttonRight1Value;
    var buttonLeft1Value;
    var buttonRight2Value;
    var buttonLeft2Value;
    var buttonRight3Value;
    var buttonLeft3Value;

    var buttonDown1Style;
    var buttonUp1Style;
    var buttonDown2Style;
    var buttonUp2Style;
    var buttonDown3Style;
    var buttonUp3Style;
    var buttonDown1Value;
    var buttonUp1Value;
    var buttonDown2Value;
    var buttonUp2Value;
    var buttonDown3Value;
    var buttonUp3Value;

    var hard = "false";
    var NumOfClick;
    var numberOfClickDone;
    var NumAllowed = 2;
    var numAllowedDone;
    var LastButton;

    var colChanges1 = new Array(7);
    colChanges1 = [0, 6, 1, 2, 3, 4, 5];

    var colChanges2 = new Array(7);
    colChanges2 = [0, 2, 3, 4, 5, 6, 1];


    var arrImages = new Array(6);
    for (var i = 0; i < 6; i++) {
        arrImages[i] = new Array(6);
    }

    var arrImagesCol = new Array(8);
    for (var i = 0; i < 8; i++) {
        arrImagesCol[i] = new Array(8);
    }

    var arrOriginal = new Array(8);
    for (var i = 0; i < 8; i++) {
        arrOriginal[i] = new Array(8);
    }

    var arrUndo = new Array(8);
    for (var i = 0; i < 8; i++) {
        arrUndo[i] = new Array(8);
    }

    var arrChangedtabindex = new Array(8);
    for (var i = 0; i < 8; i++) {
        arrChangedtabindex[i] = new Array(8);
    }

    var arrChangedImage = new Array(8);
    for (var i = 0; i < 8; i++) {
        arrChangedImage[i] = new Array(8);
    }

    window.opener = self;

    window.onload = function () {

        function makeRow(start) {
            return [
                `ImageFront${start}`,
                `ImageFront${start + 1}`,
                `ImageFront${start + 2}`,
                `ImageBack${start + 2}`,
                `ImageBack${start + 1}`,
                `ImageBack${start}`
            ];
        }

        window.pBoxNewCanId = [
            makeRow(1),
            makeRow(4),
            makeRow(7),
            makeRow(10),
            makeRow(13),
            makeRow(16),
            makeRow(19),
            makeRow(22)
        ];

        window.pBoxDisplayId = [...window.pBoxNewCanId];

        saveOriginalImage();
        reloadOriginalImage();
        retrieveButtons();

        window.buttonColor1.style.background = "";
        window.buttonColor2.style.background = "";
        window.buttonColor3.style.background = "";
        window.buttonColor4.style.background = "";
        window.buttonColor5.style.background = "";

        document.getElementById('LabelGoodWork').style.display = 'none';
    };

    function saveOriginalImage() {
        for (let row = 0; row < 8; row++) {
            retrieveRow2(row); // fills arrImages[] for this row

            for (let col = 0; col < 6; col++) {
                const el = document.getElementById(arrImages[col]);

                arrOriginal[row][col] = {
                    src: el.src,
                    index: el.tabIndex
                };
            }
        }
    }

    function reloadOriginalImage() {
        for (let row = 0; row < 8; row++) {
            retrieveRow2(row);
            for (let col = 0; col < 6; col++) {
                document.getElementById(arrImages[col]).src =
                    arrOriginal[row][col].src;
            }
        }

        // DO NOT SAVE ORIGINAL HERE
        saveChangeImage();

        VerifyPuzzle();
        retrieveButtons();

        buttonColor1.style.background = "green";
        buttonColor2.style.background = "";
        buttonColor3.style.background = "";
        buttonColor4.style.background = "";
        buttonColor5.style.background = "";

        resetButton();
        window.hard = "false";
        document.getElementById('LabelGoodWork').style.display = 'none';
    }

    function changeCanImage(newCan) {

        reloadOriginalImage();

        var img = document.getElementById('Mirror');
        if (newCan === "Canadian" || newCan === "RedBull") {
            img.src = 'MirrorLong.png';
        } else {
            img.src = 'MirrorShort.png';
        }

        for (var row = 0; row < 8; row++) {
            retrieveNewCanRow2(row);
            for (var column = 0; column < 6; column++) {
                document.getElementById(arrImages[column]).src = document.getElementById(arrImages[column]).src.replace(window.oldCan, newCan);
            }
        }

        window.oldCan = newCan;
        window.saveNewCan = newCan;
        saveOriginalImage();
        saveChangeImage();
        VerifyPuzzle();
    }
    function saveImagesForUndo() {

        // Save images + tabindex
        for (let row = 0; row < 8; row++) {
            retrieveRow2(row);
            for (let col = 0; col < 6; col++) {
                const el = document.getElementById(arrImages[col]);
                window.arrUndo[row][col] = { src: el.src, index: el.tabIndex };
            }
        }

        // Helper to read visibility
        const vis = id => window.getComputedStyle(document.getElementById(id)).visibility;

        // Horizontal buttons
        buttonRight1Value = vis('buttonRight1');
        buttonLeft1Value = vis('buttonLeft1');
        buttonRight2Value = vis('buttonRight2');
        buttonLeft2Value = vis('buttonLeft2');
        buttonRight3Value = vis('buttonRight3');
        buttonLeft3Value = vis('buttonLeft3');

        // Vertical buttons
        buttonDown1Value = vis('buttonMoveDown1');
        buttonUp1Value = vis('buttonMoveUp1');
        buttonDown2Value = vis('buttonMoveDown2');
        buttonUp2Value = vis('buttonMoveUp2');
        buttonDown3Value = vis('buttonMoveDown3');
        buttonUp3Value = vis('buttonMoveUp3');

        // Click counters
        numberOfClickDone = window.NumOfClick;
        numAllowedDone = window.NumAllowed;
    }

    function UndoLastMove() {

        retrieveArrowButtonsUpDown();
        retrieveArrowButtonsLeftRight();

        // Restore images + tabindex
        for (let row = 0; row < 8; row++) {
            retrieveRow2(row);
            for (let col = 0; col < 6; col++) {
                const el = document.getElementById(arrImages[col]);
                el.src = window.arrUndo[row][col].src;
                el.tabIndex = window.arrUndo[row][col].index;
            }
        }

        // Helper to set visibility
        const setVis = (id, value) =>
            document.getElementById(id).style.visibility = value;

        // Horizontal buttons
        setVis('buttonRight1', buttonRight1Value);
        setVis('buttonLeft1', buttonLeft1Value);
        setVis('buttonRight2', buttonRight2Value);
        setVis('buttonLeft2', buttonLeft2Value);
        setVis('buttonRight3', buttonRight3Value);
        setVis('buttonLeft3', buttonLeft3Value);

        // Vertical buttons
        setVis('buttonMoveDown1', buttonDown1Value);
        setVis('buttonMoveUp1', buttonUp1Value);
        setVis('buttonMoveDown2', buttonDown2Value);
        setVis('buttonMoveUp2', buttonUp2Value);
        setVis('buttonMoveDown3', buttonDown3Value);
        setVis('buttonMoveUp3', buttonUp3Value);

        // Restore counters
        window.NumOfClick = numberOfClickDone - 1;
        window.NumAllowed = numAllowedDone;

        saveChangeImage();
        VerifyPuzzle();
    }

    function saveChangeImage() {
        for (var row = 0; row < 8; row++) {
            retrieveRow2(row);
            for (var column = 0; column < 6; column++) {
                window.arrChangedImage[row][column] = { src: document.getElementById(arrImages[column]).src, index: document.getElementById(arrImages[column]).tabIndex };
            }
        }
    }
    function btnSaveCurrentGame() {

        // Save images + tabindex
        for (let row = 0; row < 8; row++) {
            retrieveNewCanRow2(row);
            for (let col = 0; col < 6; col++) {
                const el = document.getElementById(arrImages[col]);
                localStorage.setItem(`src${col}${row}`, el.src);
                localStorage.setItem(`index${col}${row}`, el.tabIndex);
            }
        }

        // Helper to read visibility
        const vis = id => window.getComputedStyle(document.getElementById(id)).visibility;

        // Horizontal buttons
        localStorage.setItem('buttonRight1Value', vis('buttonRight1'));
        localStorage.setItem('buttonLeft1Value', vis('buttonLeft1'));
        localStorage.setItem('buttonRight2Value', vis('buttonRight2'));
        localStorage.setItem('buttonLeft2Value', vis('buttonLeft2'));
        localStorage.setItem('buttonRight3Value', vis('buttonRight3'));
        localStorage.setItem('buttonLeft3Value', vis('buttonLeft3'));

        // Vertical buttons
        localStorage.setItem('buttonDown1Value', vis('buttonMoveDown1'));
        localStorage.setItem('buttonUp1Value', vis('buttonMoveUp1'));
        localStorage.setItem('buttonDown2Value', vis('buttonMoveDown2'));
        localStorage.setItem('buttonUp2Value', vis('buttonMoveUp2'));
        localStorage.setItem('buttonDown3Value', vis('buttonMoveDown3'));
        localStorage.setItem('buttonUp3Value', vis('buttonMoveUp3'));

        // Difficulty button colors
        const saveColor = id =>
            localStorage.setItem(id, document.getElementById(id).style.backgroundColor);

        saveColor('buttonTooEasy');
        saveColor('buttonEasy');
        saveColor('buttonHard');
        saveColor('buttonXtraHard');
        saveColor('btnLoadImage');

        // Counters + flags
        localStorage.setItem('NumOfClick', window.NumOfClick);
        localStorage.setItem('NumAllowed', window.NumAllowed);
        localStorage.setItem('hard', window.hard);
        localStorage.setItem('oldCan', window.oldCan);
    }

    function btnLoadSavedGame() {

        window.saveNewCan = localStorage.getItem('oldCan');
        if (!window.saveNewCan) return;

        changeCanImage(window.saveNewCan);

        // Restore images + tabindex
        for (let row = 0; row < 8; row++) {
            retrieveNewCanRow2(row);
            for (let col = 0; col < 6; col++) {
                const el = document.getElementById(arrImages[col]);
                el.src = localStorage.getItem(`src${col}${row}`);
                el.tabIndex = localStorage.getItem(`index${col}${row}`);
            }
        }

        // Helper to set visibility
        const setVis = (id, key) =>
            document.getElementById(id).style.visibility = localStorage.getItem(key);

        // Horizontal buttons
        setVis('buttonRight1', 'buttonRight1Value');
        setVis('buttonLeft1', 'buttonLeft1Value');
        setVis('buttonRight2', 'buttonRight2Value');
        setVis('buttonLeft2', 'buttonLeft2Value');
        setVis('buttonRight3', 'buttonRight3Value');
        setVis('buttonLeft3', 'buttonLeft3Value');

        // Vertical buttons
        setVis('buttonMoveDown1', 'buttonDown1Value');
        setVis('buttonMoveUp1', 'buttonUp1Value');
        setVis('buttonMoveDown2', 'buttonDown2Value');
        setVis('buttonMoveUp2', 'buttonUp2Value');
        setVis('buttonMoveDown3', 'buttonDown3Value');
        setVis('buttonMoveUp3', 'buttonUp3Value');

        // Difficulty button colors
        const loadColor = id =>
            document.getElementById(id).style.backgroundColor = localStorage.getItem(id);

        loadColor('buttonTooEasy');
        loadColor('buttonEasy');
        loadColor('buttonHard');
        loadColor('buttonXtraHard');
        loadColor('btnLoadImage');

        // Counters + flags
        window.NumOfClick = Number(localStorage.getItem('NumOfClick'));
        window.NumAllowed = Number(localStorage.getItem('NumAllowed'));
        window.hard = localStorage.getItem('hard');

        saveChangeImage();
        VerifyPuzzle();
    }

    function reply(clickedTabIndex, clickedAlt) {

        // Track click streak
        const key = clickedAlt + clickedTabIndex;
        if (key !== window.LastButton) {
            window.NumOfClick = 1;
            window.LastButton = key;
        } else {
            window.NumOfClick++;
        }

        // SIDE movement
        if (clickedAlt === "side") {
            const move = (clickedTabIndex % 2 === 1) ? MoveRight : MoveLeft;
            move(clickedTabIndex);
        }

        // UP/DOWN movement
        if (clickedAlt === "up") {
            const move = (clickedTabIndex % 2 === 0) ? MoveDown : MoveUp;
            move(clickedTabIndex);
        }

        // HARD MODE blocking
        if (hard === "true" && NumOfClick >= NumAllowed) {
            if (clickedAlt === "side") BlockMovementSide(clickedTabIndex);
            if (clickedAlt === "up") BlockMovementTop(clickedTabIndex);
        }
    }

    function BlockMovementSide(x) {

        retrieveArrowButtonsLeftRight();

        // Reset all side buttons
        const buttons = [
            'buttonRight1', 'buttonLeft1',
            'buttonRight2', 'buttonLeft2',
            'buttonRight3', 'buttonLeft3'
        ];

        buttons.forEach(id => document.getElementById(id).style.visibility = '');

        // Map of which buttons to hide for each x
        const hideMap = {
            0: ['buttonLeft1', 'buttonLeft3', 'buttonRight1'],
            1: ['buttonRight1', 'buttonRight2', 'buttonLeft1'],
            2: ['buttonLeft1', 'buttonLeft2', 'buttonRight2'],
            3: ['buttonRight2', 'buttonRight3', 'buttonLeft2'],
            4: ['buttonLeft2', 'buttonLeft3', 'buttonRight3'],
            5: ['buttonRight1', 'buttonRight3', 'buttonLeft3']
        };

        // Hide the appropriate buttons
        hideMap[x].forEach(id =>
            document.getElementById(id).style.visibility = 'hidden'
        );
    }

    function resetButton() {
        retrieveArrowButtonsUpDown();
        retrieveArrowButtonsLeftRight();

        const buttons = [
            'buttonRight1', 'buttonLeft1',
            'buttonRight2', 'buttonLeft2',
            'buttonRight3', 'buttonLeft3',
            'buttonMoveDown1', 'buttonMoveUp1',
            'buttonMoveDown2', 'buttonMoveUp2',
            'buttonMoveDown3', 'buttonMoveUp3'
        ];

        buttons.forEach(id =>
            document.getElementById(id).style.visibility = ''
        );
    }

    function BlockMovementTop(x) {

        retrieveArrowButtonsUpDown();

        // Reset all vertical buttons
        const buttons = [
            'buttonMoveDown1', 'buttonMoveUp1',
            'buttonMoveDown2', 'buttonMoveUp2',
            'buttonMoveDown3', 'buttonMoveUp3'
        ];

        buttons.forEach(id =>
            document.getElementById(id).style.visibility = ''
        );

        // Map of which buttons to hide for each x
        const hideMap = {
            0: ['buttonMoveUp1', 'buttonMoveUp3', 'buttonMoveDown1'],
            1: ['buttonMoveDown1', 'buttonMoveDown2', 'buttonMoveUp1'],
            2: ['buttonMoveUp1', 'buttonMoveUp2', 'buttonMoveDown2'],
            3: ['buttonMoveDown1', 'buttonMoveDown3', 'buttonMoveUp3'],
            4: ['buttonMoveUp2', 'buttonMoveUp3', 'buttonMoveDown3'],
            5: ['buttonMoveDown2', 'buttonMoveDown3', 'buttonMoveUp2']
        };

        // Hide the appropriate buttons
        hideMap[x].forEach(id =>
            document.getElementById(id).style.visibility = 'hidden'
        );
    }

    function retrieveButtons() {
        const ids = [
            'buttonTooEasy',
            'buttonEasy',
            'buttonHard',
            'buttonXtraHard',
            'btnLoadImage'
        ];

        ids.forEach((id, i) => {
            window['buttonColor' + (i + 1)] = document.getElementById(id);
            window['buttonColor' + (i + 1)].style.background = '';
        });
    }

    function retrieveArrowButtonsLeftRight() {
        const ids = [
            'buttonRight1', 'buttonLeft1',
            'buttonRight2', 'buttonLeft2',
            'buttonRight3', 'buttonLeft3'
        ];

        ids.forEach(id => {
            window[id] = document.getElementById(id);
        });
    }

    function retrieveArrowButtonsUpDown() {
        const ids = [
            'buttonMoveDown1', 'buttonMoveUp1',
            'buttonMoveDown2', 'buttonMoveUp2',
            'buttonMoveDown3', 'buttonMoveUp3'
        ];

        ids.forEach(id => {
            window[id] = document.getElementById(id);
        });
    }

    function setDifficulty(buttonIndex, shuffle, hardMode, allowedMoves) {

        reloadOriginalImage();   // restores original correctly

        if (shuffle) ShuffleTheCan();  // now shuffles from true original

        retrieveButtons();
        window['buttonColor' + buttonIndex].style.background = 'green';

        window.hard = hardMode ? 'true' : 'false';
        window.NumAllowed = allowedMoves;

        saveOriginalImage();     // NOW we save the shuffled state as the new baseline
        saveChangeImage();
        VerifyPuzzle();
    }


    function btnTooEasy() {
        setDifficulty(1, false, false, 1000);
    }

    function btnEasy() {
        setDifficulty(2, true, false, 1000);
    }

    function btnHard() {
        setDifficulty(3, true, true, 2);
    }

    function btnXtraHard() {
        setDifficulty(4, true, true, 1);
    } 

    function btnTooEasy() {

        reloadOriginalImage();
        saveOriginalImage();
        saveChangeImage();
        VerifyPuzzle();
        retrieveButtons();
        window.buttonColor1.style.background = "green";
        window.hard = "false";
    }

    function btnEasy() {

        reloadOriginalImage();
        ShuffleTheCan();
        retrieveButtons();
        window.buttonColor2.style.background = "green";
        window.hard = "false";
        window.NumAllowed = 1000;
    }

    function btnHard() {
        reloadOriginalImage();
        ShuffleTheCan();
        retrieveButtons();
        window.buttonColor3.style.background = "green";
        window.hard = "true";
        window.NumAllowed = 2;
    }

    function closeMe() { 
        window.close();
    } 

    function btnXtraHard() {
        reloadOriginalImage();
        ShuffleTheCan();
        retrieveButtons();
        window.buttonColor4.style.background = "green";
        window.hard = "true";
        window.NumAllowed = 1;
    }


    function ShuffleTheCan() {

        // Proper random integer between 1 and 5
        const iterations = Math.floor(Math.random() * 5) + 1;

        for (let x = 0; x < iterations; x++) {
            let y = (x + 1) % 6; // wrap automatically
            MoveLeft(y);
            MoveUp(y);
            MoveLeft(y);
        }

        saveChangeImage();
        saveImagesForUndo();
        VerifyPuzzle();
    }

    function MoveRight(row) {
        saveImagesForUndo();
        retrieveRow(row);

        const ids = [image0, image1, image2, image3, image4, image5];

        for (let i = 0; i < 6; i++) {
            const target = document.getElementById(ids[(i + 1) % 6]);
            target.src = arrChangedImage[row][i].src;
            target.tabIndex = arrChangedImage[row][i].index;
        }

        loadImage(image3, image0);
        saveChangeImage();
        VerifyPuzzle();
    }

    function MoveLeft(row) {
        saveImagesForUndo();
        retrieveRow(row);

        const ids = [image0, image1, image2, image3, image4, image5];

        for (let i = 0; i < 6; i++) {
            const sourceIndex = (i + 1) % 6; // left rotation
            const target = document.getElementById(ids[i]);
            target.src = arrChangedImage[row][sourceIndex].src;
            target.tabIndex = arrChangedImage[row][sourceIndex].index;
        }

        loadImage(image2, image5);
        saveChangeImage();
        VerifyPuzzle();
    }

    function loadImage(flipImage1, flipImage2) {

        function flip(id) {
            return new Promise(resolve => {
                const img = new Image();
                img.onload = function () {
                    const canvas = document.createElement('canvas');
                    const ctx = canvas.getContext('2d');

                    canvas.width = img.width;
                    canvas.height = img.height;

                    ctx.save();
                    ctx.scale(-1, 1);
                    ctx.translate(-img.width, 0);
                    ctx.drawImage(img, 0, 0);
                    ctx.restore();

                    document.getElementById(id).src = canvas.toDataURL();

                    resolve();
                };
                img.src = document.getElementById(id).src;
            });
        }

        Promise.all([
            flip(flipImage1),
            flip(flipImage2)
        ]).then(() => {
            saveChangeImage();
        });
    }

    function MoveDown(col) {
        saveImagesForUndo();
        retrieveCol(col);

        const ids = [image1, image2, image3, image4, image5, image6];

        // Down rotation: new[i] = old[(i + 5) % 6]
        for (let i = 0; i < 6; i++) {
            const srcIndex = (i + 5) % 6; // equivalent to your original mapping
            const el = document.getElementById(ids[i]);
            el.src = arrChangedImage[srcIndex + 1][col].src;
            el.tabIndex = arrChangedImage[srcIndex + 1][col].index;
        }

        saveChangeImage();
        VerifyPuzzle();
    }

    function MoveUp(col) {
        saveImagesForUndo();
        retrieveCol(col);

        const ids = [image1, image2, image3, image4, image5, image6];

        // Up rotation: new[i] = old[(i + 1) % 6]
        for (let i = 0; i < 6; i++) {
            const srcIndex = (i + 1) % 6;
            const el = document.getElementById(ids[i]);
            el.src = arrChangedImage[srcIndex + 1][col].src;
            el.tabIndex = arrChangedImage[srcIndex + 1][col].index;
        }

        saveChangeImage();
        VerifyPuzzle();
    }


    function retrieveNewCanRow2(row) {
        for (let x = 0; x < 6; x++) {
            arrImages[x] = window.pBoxNewCanId[row][x];
        }
    }


    function retrieveRow(row) {
        image0 = window.pBoxDisplayId[row][0];
        image1 = window.pBoxDisplayId[row][1];
        image2 = window.pBoxDisplayId[row][2];
        image3 = window.pBoxDisplayId[row][3];
        image4 = window.pBoxDisplayId[row][4];
        image5 = window.pBoxDisplayId[row][5];
    }

    function retrieveRow2(row) {
        for (let x = 0; x < 6; x++) {
            arrImages[x] = window.pBoxDisplayId[row][x];
        }
    }
    function retrieveCol(col) {
        image1 = window.pBoxDisplayId[1][col];
        image2 = window.pBoxDisplayId[2][col];
        image3 = window.pBoxDisplayId[3][col];
        image4 = window.pBoxDisplayId[4][col];
        image5 = window.pBoxDisplayId[5][col];
        image6 = window.pBoxDisplayId[6][col];
    }
    function VerifyPuzzle() {

        let correct = 0;

        for (let row = 0; row < 8; row++) {
            retrieveRow2(row);  // fills arrImages[] with the 6 IDs for this row

            for (let col = 0; col < 6; col++) {
                const expected = arrOriginal[row][col].index;
                const actual = document.getElementById(arrImages[col]).tabIndex;

                if (expected == actual) {
                    correct++;
                }
            }
        }

        window.verifyResult = correct - 12;

        // Update UI once
        document.getElementById('theTextBox').value = window.verifyResult.toString();

        if (correct === 48) {
            document.getElementById('LabelGoodWork').style.display = 'inherit';
        } else {
            document.getElementById('LabelGoodWork').style.display = 'none';
        }
    }

    function moveArrow(imageId) {

        const img = new Image();
        img.src = document.getElementById(imageId).src;

        img.onload = function () {

            const frameCount = 12;
            const frameWidth = img.width / frameCount;
            const frameHeight = img.height;

            // Create a single canvas for animation
            const canvas = document.createElement("canvas");
            canvas.width = frameWidth;
            canvas.height = frameHeight;
            canvas.style.position = "absolute";
            canvas.style.left = "0px";
            canvas.style.top = "20px";
            document.body.appendChild(canvas);

            const ctx = canvas.getContext("2d");

            let frame = 0;
            let x = 0;
            let dx = 2;

            function animate() {

                // Flip direction at x = 300
                if (x >= 300) dx = -2;
                if (x <= 0) dx = 2;

                // Draw current frame
                ctx.clearRect(0, 0, frameWidth, frameHeight);
                ctx.drawImage(
                    img,
                    frame * frameWidth, 0, frameWidth, frameHeight,
                    0, 0, frameWidth, frameHeight
                );

                // Move canvas
                canvas.style.left = x + "px";

                // Advance frame + position
                frame = (frame + 1) % frameCount;
                x += dx;

                requestAnimationFrame(animate);
            }

            animate();
        };
    }

</script>
<html xmlns="http://www.w3.org/1999/xhtml">

<body>
    <form runat="server">
        <div class="container-fluid">

            <div class="row">
                <div class=" col-xs-12 col-sm-12 col-md-12" style="height: 20px;">
                </div>
            </div>
            <div class="row  container-fluid">
                <div class=" col-xs-2 col-sm-2 col-md-2">
                    <div class="row  " style="margin-bottom: -13px; padding-left: 15px;">
                        <div>
                            <button type="button" id="ButtonUndo" runat="server" onclick="UndoLastMove(); return false;" style="height: 40px; width: 100px;" class="img-responsive">Undo last Move</button>
                        </div>
                    </div>
                    <br />
                    <div>

                        <label>Change Can</label>

                        <select id="listofcans" onchange="changeCanImage(this.value)" style="padding-left: 10px;">
                            <option value="Coke">Coke</option>
                            <option value="CokePepsi">CokePepsi</option>
                            <option value="Kokanee">Kokanee</option>
                           <%-- <option value="Canadian">Canadian</option>--%>
                            <option value="RedBull">RedBull</option>
                            <option value="Campbell">Campbell</option>
                            <option value="Grasshopper">Grasshopper</option>
                            <%--<option value="MillerLite">MillerLite</option>--%>
                            <option value="PeopleBeer">PeopleBeer</option>
                        </select>
                    </div>
                </div>



                <div class=" col-xs-4 col-sm-4 col-md-4">
                    <img src="downArrow.t.bmp" id="buttonMoveDown1" class=" img-responsive " onclick="reply(this.tabIndex, this.alt )" alt="up" tabindex="0" visible="True" />
                    <img src="upArrow.t.bmp" id="buttonMoveUp1" class="img-responsive " onclick="reply(this.tabIndex, this.alt )" alt="up" tabindex="1" visible="True" />
                    <img src="downArrow.t.bmp" id="buttonMoveDown2" class="img-responsive " onclick="reply(this.tabIndex, this.alt )" alt="up" tabindex="2" visible="True" />

                </div>
                <div class=" col-xs-4 col-sm-4 col-md-4" style="margin-left: -40px">
                    <img src="upArrow.t.bmp" id="buttonMoveUp2" class=" img-responsive " onclick="reply(this.tabIndex, this.alt )" alt="up" tabindex="5" visible="True" />
                    <img src="downArrow.t.bmp" id="buttonMoveDown3" class="img-responsive " onclick="reply(this.tabIndex, this.alt )" alt="up" tabindex="4" visible="True" />
                    <img src="upArrow.t.bmp" id="buttonMoveUp3" class=" img-responsive " onclick="reply(this.tabIndex, this.alt )" alt="up" tabindex="3" visible="True" />

                </div>
                <div class=" col-xs-2 col-sm-2 col-md-2">
                    <asp:Label ID="LabelGoodWork" runat="server" Text="Good Work!" Style="width: 100px; display: none; font-weight: bold"></asp:Label>
                </div>
            </div>

            <div class="row  container-fluid">
                <div class=" col-xs-12 col-sm-12 col-md-12" style="height: 20px;">
                </div>
            </div>
            <div class="row  container-fluid">
                <div class=" col-xs-2 col-sm-2 col-md-2">
                </div>

                <div id="ImageFrontContainer" class="col-xs-4 col-sm-4 col-md-4  container-fluid">
                    <div class="row">
                        <div>
                            <img src="Images/Coke-0-0.png" id="ImageFront1" tabindex="1" class="img-responsive" alt="My Image" />
                            <img src="Images/Coke-0-1.png" id="ImageFront2" tabindex="2" class="img-responsive" alt="My Image" />
                            <img src="Images/Coke-0-2.png" id="ImageFront3" tabindex="3" class="img-responsive" alt="My Image" />
                        </div>
                    </div>
                    <div class="row">
                        <div>
                            <img src="rightArrow.t.bmp" id="buttonRight1" class="img-responsive  arrowAlign " onclick="reply(this.tabIndex, this.alt )" alt="side" tabindex="1" visible="True" />
                            <img src="Images/Coke-1-0.png" id="ImageFront4" tabindex="4" class="img-responsive" alt="My Image" />
                            <img src="Images/Coke-1-1.png" id="ImageFront5" tabindex="5" class="img-responsive" alt="My Image" />
                            <img src="Images/Coke-1-2.png" id="ImageFront6" tabindex="6" class="img-responsive" alt="My Image" />
                        </div>
                    </div>
                    <div class="row">
                        <div>
                            <img src="leftArrow.t.bmp" id="buttonLeft1" class="img-responsive  arrowAlign" onclick="reply(this.tabIndex, this.alt )" alt="side" tabindex="2" visible="True" />
                            <img src="Images/Coke-2-0.png" id="ImageFront7" tabindex="7" class="img-responsive" alt="My Image" />
                            <img src="Images/Coke-2-1.png" id="ImageFront8" tabindex="8" class="img-responsive" alt="My Image" />
                            <img src="Images/Coke-2-2.png" id="ImageFront9" tabindex="9" class="img-responsive" alt="My Image" />
                        </div>
                    </div>
                    <div class="row">
                        <div>
                            <img src="rightArrow.t.bmp" id="buttonRight2" class="img-responsive  arrowAlign " onclick="reply(this.tabIndex, this.alt )" alt="side" tabindex="3" visible="True" />
                            <img src="Images/Coke-3-0.png" id="ImageFront10" tabindex="10" class="img-responsive" alt="My Image" />
                            <img src="Images/Coke-3-1.png" id="ImageFront11" tabindex="11" class="img-responsive" alt="My Image" />
                            <img src="Images/Coke-3-2.png" id="ImageFront12" tabindex="12" class="img-responsive" alt="My Image" />
                        </div>
                    </div>
                    <div class="row">
                        <div>
                            <img src="leftArrow.t.bmp" id="buttonLeft2" class="img-responsive  arrowAlign" onclick="reply(this.tabIndex, this.alt )" alt="side" tabindex="4" visible="True" />
                            <img src="Images/Coke-4-0.png" id="ImageFront13" tabindex="13" class="img-responsive" alt="My Image" />
                            <img src="Images/Coke-4-1.png" id="ImageFront14" tabindex="14" class="img-responsive" alt="My Image" />
                            <img src="Images/Coke-4-2.png" id="ImageFront15" tabindex="15" class="img-responsive" alt="My Image" />
                        </div>
                    </div>
                    <div class="row">
                        <div>
                            <img src="rightArrow.t.bmp" id="buttonRight3" class="img-responsive  arrowAlign " onclick="reply(this.tabIndex, this.alt )" alt="side" tabindex="5" visible="True" />
                            <img src="Images/Coke-5-0.png" id="ImageFront16" tabindex="16" class="img-responsive" alt="My Image" />
                            <img src="Images/Coke-5-1.png" id="ImageFront17" tabindex="17" class="img-responsive" alt="My Image" />
                            <img src="Images/Coke-5-2.png" id="ImageFront18" tabindex="18" class="img-responsive" alt="My Image" />
                        </div>
                    </div>
                    <div class="row">
                        <div>
                            <img src="leftArrow.t.bmp" id="buttonLeft3" class="img-responsive  arrowAlign" onclick="reply(this.tabIndex, this.alt )" alt="side" tabindex="6" visible="True" />
                            <img src="Images/Coke-6-0.png" id="ImageFront19" tabindex="19" class="img-responsive" alt="My Image" />
                            <img src="Images/Coke-6-1.png" id="ImageFront20" tabindex="20" class="img-responsive" alt="My Image" />
                            <img src="Images/Coke-6-2.png" id="ImageFront21" tabindex="21" class="img-responsive" alt="My Image" />
                        </div>
                    </div>
                    <div class="row">
                        <div>

                            <img src="Images/Coke-7-0.png" id="ImageFront22" tabindex="22" class="img-responsive " alt="My Image" />
                            <img src="Images/Coke-7-1.png" id="ImageFront23" tabindex="23" class="img-responsive " alt="My Image" />
                            <img src="Images/Coke-7-2.png" id="ImageFront24" tabindex="24" class="img-responsive " alt="My Image" />
                        </div>
                    </div>
                </div>


                <div id="ImageBackContainer" class=" col-xs-4 col-sm-4 col-md-4  container-fluid">
                    <div class="row " style="padding-top: 30px;">
                        <asp:Image ID="Mirror" runat="server" ImageUrl="MirrorShort.png" class="img-responsive " BorderStyle="Solid" BorderColor="Red"
                            Style="border: 5px solid black; transform: perspective( 400px ) rotateY( 160deg ); position: absolute; perspective-origin: 25% 75%; opacity: .4; margin-left: -55px; width: auto; height: auto; top: 0;" />

                        <div>
                            <img src="Images/Coke-0-3.png" id="ImageBack1" tabindex="25" />
                            <img src="Images/Coke-0-4.png" id="ImageBack2" tabindex="26" />
                            <img src="Images/Coke-0-5.png" id="ImageBack3" tabindex="27" />
                        </div>
                    </div>
                    <div class="row  ">
                        <div>
                            <img src="Images/Coke-1-3.png" id="ImageBack4" tabindex="28" />
                            <img src="Images/Coke-1-4.png" id="ImageBack5" tabindex="29" />
                            <img src="Images/Coke-1-5.png" id="ImageBack6" tabindex="30" />
                        </div>
                    </div>
                    <div class="row  ">
                        <div>
                            <img src="Images/Coke-2-3.png" id="ImageBack7" tabindex="31" />
                            <img src="Images/Coke-2-4.png" id="ImageBack8" tabindex="32" />
                            <img src="Images/Coke-2-5.png" id="ImageBack9" tabindex="33" />
                        </div>
                    </div>

                    <div class="row  ">
                        <div>
                            <img src="Images/Coke-3-3.png" id="ImageBack10" tabindex="34" />
                            <img src="Images/Coke-3-4.png" id="ImageBack11" tabindex="35" />
                            <img src="Images/Coke-3-5.png" id="ImageBack12" tabindex="36" />
                        </div>
                    </div>
                    <div class="row  ">
                        <div>
                            <img src="Images/Coke-4-3.png" id="ImageBack13" tabindex="37" />
                            <img src="Images/Coke-4-4.png" id="ImageBack14" tabindex="38" />
                            <img src="Images/Coke-4-5.png" id="ImageBack15" tabindex="39" />
                        </div>
                    </div>
                    <div class="row  ">
                        <div>
                            <img src="Images/Coke-5-3.png" id="ImageBack16" tabindex="40" />
                            <img src="Images/Coke-5-4.png" id="ImageBack17" tabindex="41" />
                            <img src="Images/Coke-5-5.png" id="ImageBack18" tabindex="42" />
                        </div>
                    </div>
                    <div class="row  ">
                        <div>
                            <img src="Images/Coke-6-3.png" id="ImageBack19" tabindex="43" />
                            <img src="Images/Coke-6-4.png" id="ImageBack20" tabindex="44" />
                            <img src="Images/Coke-6-5.png" id="ImageBack21" tabindex="45" />

                        </div>
                    </div>
                    <div class="row  ">
                        <div>
                            <img src="Images/Coke-7-3.png" id="ImageBack22" tabindex="46" />
                            <img src="Images/Coke-7-4.png" id="ImageBack23" tabindex="47" />
                            <img src="Images/Coke-7-5.png" id="ImageBack24" tabindex="48" />

                        </div>
                    </div>
                </div>
                <div class=" col-xs-2 col-sm-2 col-md-2  ">
                    <div class="row" style="margin-left: 10px;">
                        <div class="row">
                            <table>
                                <tr>
                                    <td>
                                        <asp:TextBox ID="theTextBox" runat="server" Width="40px"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:Label ID="aLabel" runat="server" Text="&nbsp; of 36"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <br />
                        <div class="row" style="margin-bottom: -13px;">
                            <div>
                                <button id="buttonTooEasy" runat="server" onclick="btnTooEasy(); return false;" style="width: 100px;" class="img-responsive elButton">Practice</button>
                            </div>
                        </div>
                        <br />
                        <div class="row  " style="margin-bottom: -13px;">
                            <div>
                                <button type="button" id="buttonEasy" runat="server" onclick="btnEasy(); return false;" style="width: 100px;" class="img-responsive">Easy</button>
                            </div>
                        </div>
                        <br />
                        <div class="row  " style="margin-bottom: -13px;">
                            <div>
                                <button type="button" id="buttonHard" runat="server" onclick="btnHard(); return false;" style="width: 100px;" class="img-responsive">Hard</button>
                            </div>
                        </div>
                        <br />
                        <div class="row  " style="margin-bottom: -13px;">
                            <div>
                                <button type="button" id="buttonXtraHard" runat="server" onclick="btnXtraHard(); return false;" style="width: 100px;" class="img-responsive">Xtra Hard</button>
                            </div>
                        </div>
                        <br />
                        <div class="row  " style="margin-bottom: -13px;">
                            <div>
                                <button type="button" id="btnLoadImage" runat="server" onclick="reloadOriginalImage(); return false;" style="width: 100px;" class="img-responsive">Reload</button>
                            </div>
                        </div>
                        <br />
                        <div class="row  " style="margin-bottom: -13px;">
                            <div>
                                <button type="button" id="btnSave" runat="server" onclick="btnSaveCurrentGame();" style="width: 100px;" class="img-responsive">Save Current Game</button>
                            </div>
                        </div>
                        <br />

                        <div class="row  " style="margin-bottom: -13px;">
                            <div>
                                <button type="button" id="btnReloadSaved" runat="server" onclick="btnLoadSavedGame();" style="width: 100px;" class="img-responsive">Load Last Saved Game</button>
                            </div>
                        </div>
                        <br />
                        <div class="row  " style="margin-bottom: -13px;">
                            <div>
                                <button type="button" id="buttonExit" runat="server" onclick="closeMe()" style="width: 100px;" class="img-responsive">Close</button>
                            </div>
                        </div>
                        <br />
                        <br />
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
