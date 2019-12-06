import QtQml 2.2
import QOwnNotesTypes 1.0

/// Simple script, that creates a button and a context menu item that insert text, defined in the script settings.

Script { 
    property string menuName
    property string buttonName
    property string buttonIcon
    
    property variant settingsVariables: [
        {
            "identifier": "menuName",
            "name": "Name of the menu item",
            "description": "",
            "type": "string",
            "default": "Insert date",
        },
        {
            "identifier": "buttonName",
            "name": "Name of the button",
            "description": "",
            "type": "string",
            "default": "Insert date",
        },
        {
            "identifier": "buttonIcon",
            "name": "Icon of the button",
            "description": "Name or full path to button icon. If empty, button name will be shown.",
            "type": "string",
            "default": "insert-date.svg",
        },
    ]
    
    function init() {
        script.registerCustomAction("insertDate", menuName, buttonName, buttonIcon, true)
    }
    
    function twoDigitString(int_input) {
		if (int_input < 10) {
			return ("0" + String(int_input))
		}
		else {
			return String(int_input)
		}
	}
	
    function customActionInvoked(action) {
        if (action == "insertDate") {
		    var date = new Date()

		  var day = date.getDate()
		    var month = date.getMonth() + 1
			  var year = date.getFullYear()
        var days_abbr = [
                            'Sun',
                            'Mon',
                            'Tue',
                            'Wed',
                            'Thu',
                            'Fri',
                            'Sat'
                        ];
            script.noteTextEditWrite("[" + days_abbr[date.getDay()] + " " + twoDigitString(day) + "-" + twoDigitString(month) + "-" + String(year) + "] ")
        }
    }
}

