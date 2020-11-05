// Allow only image file attachments
window.addEventListener("trix-file-accept", (e) => {
    const acceptedTypes = ["image/jpeg", "image/png"]
    const maxFileSize = 1024 * 1024 // 1MB

    if (!acceptedTypes.includes(e.file.type)) {
        e.preventDefault()
        alert("Support only jpg or png formats.")
    }

    if (e.file.size > maxFileSize) {
        e.preventDefault()
        alert("Maximum size file - 1 Megabyte.")
    }
})
