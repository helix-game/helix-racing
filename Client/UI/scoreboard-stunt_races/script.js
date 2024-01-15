const showUi = () => {
    $('.screen').removeClass('hidden')
}

const hideUi = () => {
    $('.screen').addClass('hidden')
}

let scoreboard = [
    {
        name: "Bradcoxy",
        position: 1,
        time: "00:23.12",
        you: true
    },
    {
        name: "Dobby",
        position: 2,
        time: "00:23.12",
        you: false
        }, 
        {
            name: "Carlos",
            position: 3,
            time: "00:23.12",
            you: false
        },
        {
            name: "Kravs",
            position: 4,
            time: "00:23.12",
            you: false
        }, {
            name: "Myer",
            position: 5,
            time: "00:23.12",
            you: false
        },
        {
            name: "Maker",
            position: 6,
            time: "00:23.12",
            you: false
        }, {
            name: "O1ls",
            position: 7,
            time: "00:23.12",
            you: false
        },
        {
            name: "Yamie",
            position: 8,
            time: "00:23.12",
            you: false
        },
];

$('.scoreboard .container button.ready').click(function () {
    // On click continue
})

function updateScoreboard(table) {
    $(".scoreboard .table .body").empty()
    table.sort((a, b) => a.position - b.position)

    for (let i = 0; i < scoreboard.length; i++) {

        let t = table[i].time
        
        const minutes = Math.floor(t / (1000 * 60));
        const seconds = Math.floor((t % (1000 * 60)) / 1000);
        const milliseconds = Math.floor((t % 1000));

        let element = `<div class="player ${table[i].you ? "you" : ""}">
          <p class="rank">#${table[i].position}</p>
          <p class="name">${table[i].name}</p>
          <p class="time">` + minutes + ":" + seconds + "." + milliseconds + `</p>
        </div>`

        $(".scoreboard .table .body").append(element)
    }

    let yourPosition = table.find(player => player.you).position
    $('.scoreboard .container .info .position h1').html(yourPosition + "" + `<span>${yourPosition == 1 ? "st" : yourPosition == 2 ? "nd" : yourPosition == 3 ? "rd" : "th"}</span>`)

}

function setMap(map) {
    $('.scoreboard .info .map').attr('src', map.imageUrl)
    $('.scoreboard .info .map-name h1').text(map.name)
}



Events.Subscribe("UpdateScoreboard",function(tab){

    updateScoreboard(tab)

});


Events.Subscribe("Enterboost",function(tab){

    updateScoreboard(tab)

});

//updateScoreboard(scoreboard)

setMap({
    name: "Easy Race Track 1",
    imageUrl: "./media/map1X1.png"
})
showUi()