document.addEventListener("turbolinks:load", () => {
    $(".lesson-sortable" ).sortable({
        cursor: "grabbing",
        update: (e, ui) => {
            const item = ui.item
            const item_data = item.data()
            const params = {_method: "put"}

            params[item_data.modelName] = { row_order_position: item.index() }

            $.ajax({
                type: "POST",
                url: item_data.updateUrl,
                dataType: "json",
                data: params,
            })
        }
    })
})
