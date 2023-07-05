const expandElements = shouldExpand => {
    let detailsElements = document.querySelectorAll("details");
    
    detailsElements = [...detailsElements];

    if (shouldExpand) {
        console.log("Expanding!");
        detailsElements.map(item => item.setAttribute("open", shouldExpand));
    } else {
        console.log("Collapsing!");
        detailsElements.map(item => item.removeAttribute("open"));
    }
};

function showSystemLogs(shouldShow, className) {
    document.querySelectorAll(className).forEach(function(el) {
        if (shouldShow) {
            el.style.display = 'block';
        } else {
            el.style.display = 'none';
        }
    });
}

window.onload = (function () {
    document.getElementById("expand-sections").onclick = function() {
        expandElements(true);
    };
    document.getElementById("collapse-sections").onclick = function() {
        expandElements(false);
    };

    document.getElementById('system-logs').addEventListener('change', (event) => {
      if (event.currentTarget.checked) {
        showSystemLogs(true, '.system');
      } else {
        showSystemLogs(false, '.system');
      }
    });

    document.getElementById('debug-logs').addEventListener('change', (event) => {
      if (event.currentTarget.checked) {
        showSystemLogs(true, '.debug');
      } else {
        showSystemLogs(false, '.debug');
      }
    });

    document.getElementById('error-logs').addEventListener('change', (event) => {
      if (event.currentTarget.checked) {
        showSystemLogs(true, '.error');
      } else {
        showSystemLogs(false, '.error');
      }
    });
});