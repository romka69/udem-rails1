document.addEventListener("turbolinks:load", () => {
    const videoPlayer = videojs(document.getElementById("my-video"), {
        controls: true,
        playbackRates: [0.5, 1, 1.5, 2],
        autoplay: false,
        preload: false,
        fluid: true,
        liveui: true,
        responsive: true,
        loop: false
    })

    videoPlayer.classList.add('video-js', 'vjs-big-play-centered')
})
