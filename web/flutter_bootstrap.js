{{flutter_js}}
{{flutter_build_config}}



const loadingDiv = document.createElement('div');
loadingDiv.className = "loading";
document.body.appendChild(loadingDiv);
const loaderDiv = document.createElement('div');
loaderDiv.className = "loader";
loadingDiv.appendChild(loaderDiv);

// Customize the app initialization process
_flutter.loader.load({
    onEntrypointLoaded: async function (engineInitializer) {
        const appRunner = await engineInitializer.initializeEngine();
        await appRunner.runApp();
        if (document.body.contains(loadingDiv)) {
            document.body.removeChild(loadingDiv);
        }
    }
});
