

window.addEventListener("message", (event) => {
    console.log(event.data.type)
    if (event.data.type === "showAnnouncement") {
        console.log("ANUNCIO CRIADO")
        const announcement = document.getElementById("announcement");
        announcement.style.display = "block";

        // Ocultar o anúncio após 10 segundos
        setTimeout(() => {
            announcement.style.display = "none";
        }, 60000);
    }
});
