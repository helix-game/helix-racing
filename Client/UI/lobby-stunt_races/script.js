const gamemodes = $('.gamemode')
const buttonReady = $('.lobby .ready button.ready-to-play')

let selectedGamemode = "trackrace"

gamemodes.on('click', function () {
    gamemodes.removeClass('selected')
    $(this).addClass('selected')
    $('.lobby .ready h1').text($(this).find('.name').text() + " mode")
    selectedGamemode = $(this).attr('data-mode')
})

buttonReady.on('click', function () {
    if ($(this).hasClass('unavailable')) {
        return
    }

    $(this).addClass('transitioning')

    if ($(this).hasClass('active')) {
        $(this).removeClass('active')
        $(this).find('p').text('Ready to play')

        //turn off mm
        //alert("END MM")

        Events.Call("LeaveMM")

    } else {
        $(this).addClass('active')
        $(this).find('p').text('match making...')

        //start mm
        //alert(selectedGamemode)

        Events.Call("BeginMM",selectedGamemode)

    }

    setTimeout(() => {
        $(this).removeClass('transitioning')
    }, 300)
    
})

const showUi = () => {
    $('.screen').removeClass('hidden')
}

const hideUi = () => {
    $('.screen').addClass('hidden')
}

const setlevel = level => {
    $('.level').html(`<p class="level">${level}</p>`)
}

const setXp = xp => {
    $('.xp-bar .fill').css('width', `${xp}%`)
}

const setModeDescriptions = modes => {

}


// Usage
const hardcodedModes = [
    {
        name: "racing",
        description: " is the ultimate challenge for speed lovers. Compete with other players or AI drivers in various tracks and earn rewards and new features.",
    },
    {
        name: "face-to-face",
        description: " is the ultimate challenge for speed lovers. Compete with other players or AI drivers in various tracks and earn rewards and new features.",
    },
    {
        name: "soccer",
        description: " is the ultimate challenge for speed lovers. Compete with other players or AI drivers in various tracks and earn rewards and new features.",
    },
    {
        name: "sumo",
        description: " is the ultimate challenge for speed lovers. Compete with other players or AI drivers in various tracks and earn rewards and new features."
    }
]
setlevel(1)
setXp(0)
showUi()


Events.Subscribe("SetupUI", function(name,lvl,prog) {
    
    $(".xp .name").text(name)
    
    setlevel(lvl)
    
    setXp(prog)
});



