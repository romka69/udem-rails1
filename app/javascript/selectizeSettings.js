document.addEventListener("turbolinks:load", () => {
    const $selectize = $(".selectize")

    if ($selectize) {
        $selectize.selectize({
            sortField: "text"
        })
    }
})
