document.addEventListener("turbolinks:load", () => {
    const $selectize = $(".selectize")

    if ($selectize) {
        $selectize.selectize({
            sortField: "text"
        })

        $(".selectize-tags").selectize({
            create: (input, callback) => {
                $.post("/tags.json", { tag: { name: input } })
                    .done((res) => {
                        callback({ value: res.id, text: res.name })
                    })
            }
        })
    }
})
