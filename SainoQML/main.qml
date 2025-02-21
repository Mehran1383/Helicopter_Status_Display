import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Window{
    id: root
    visible: true
    color: "black"
    visibility: "FullScreen"
    title: qsTr("Saino")

    Timer {
        running: true
        repeat: true
        property bool state: false
        onTriggered:{
            if(state == false){
                rect.width = 0
                info.start = true
                interval = 1000
            }
            else{
                rect.width = 500
                info.start = false
                interval = 3000

                if(info.i == 13)
                    info.i = 0
                else
                    info.i++
            }
            state = !state
        }
    }

    Timer {
        interval: 50
        running: leftGauge.opacity == 1 ? false : true
        repeat: true
        onTriggered: {
            leftGauge.opacity += 0.1
            rightGauge.opacity += 0.1
        }
    }

    Timer{
        running: true
        repeat: true
        interval: 1000
        property int cursorPosition: 0
        property string saino: "  ⓈⒶⒾⓃⓄ"
        onTriggered: {
            discriptionModel.insert(cursorPosition, {'letter':  saino[cursorPosition]})
            cursorPosition++
            if(cursorPosition == 7)
                running = false
        }
    }

    Shortcut {
        sequence: "Ctrl+Q"
        context: Qt.ApplicationShortcut
        onActivated: Qt.quit()
    }

    Image {
        id: panel
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        source: "qrc:/assets/panel.svg"

        Image {
            id:topBar
            source: "qrc:/assets/topBar.svg"
            sourceSize: Qt.size(parent.width * 0.6, parent.height * 0.15)
            anchors{
                top: parent.top
                topMargin: 26.50
                horizontalCenter: parent.horizontalCenter
            }

            Text {
                property int value: 80 * (1 - fuelIndicator.value)
                text: value.toString() + " Liter Fuel"
                anchors.left: parent.left
                anchors.leftMargin: 230
                anchors.top: parent.top
                anchors.topMargin: 25
                color: value < 20 ? "red" : "black"
                font.pixelSize: 20
            }

            Text {
                property int value: 100 * (1 - batteryIndicator.value)
                text: value.toString() + "% Charge"
                anchors.right: parent.right
                anchors.rightMargin: 230
                anchors.top: parent.top
                anchors.topMargin: 25
                color: value < 20 ? "red" : "black"
                font.pixelSize: 20
            }

            ListView {
                id: discription
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                width: 300; height: 25
                orientation: ListView.Horizontal
                interactive: false

                model: ListModel { id: discriptionModel }

                delegate: Text {
                    font.pixelSize: 50
                    text: letter
                    transformOrigin: Item.BottomLeft
                }

                add: Transition {
                    NumberAnimation { property: 'opacity'; from: 0; to: 1.0; duration: 400 }
                    NumberAnimation { property: 'rotation'; from: 65; to: 0; duration: 400 }
                }
            }
        }

        Image {
            id: battery
            property bool indicator : batteryIndicator.value >= 0.8 ? 1 : 0
            width: 50
            height: 50
            ToolTip.text: "battery is running out"
            ToolTip.visible: indicator ? batteryMA.containsMouse : false
            MouseArea {
                id: batteryMA
                anchors.fill: parent
                hoverEnabled: true
            }
            source: indicator ? "qrc:/assets/battery_red.svg" : "qrc:/assets/battery.svg"
            opacity: indicator ? 0 : 1
            anchors
            {
                right: topBar.left
                rightMargin: 200
                verticalCenter: topBar.verticalCenter
                verticalCenterOffset: 40
            }
            SequentialAnimation {
                running: battery.indicator
                loops: Animation.Infinite
                OpacityAnimator {
                    target: battery
                    from: 0;
                    to: 1;
                    duration: 700
                }
                OpacityAnimator {
                    target: battery
                    from: 1;
                    to: 0;
                    duration: 700
                }
            }
        }

        Image {
            id: fuel
            property bool indicator : fuelIndicator.value >= 0.8 ? 1 : 0
            width: 50
            height: 50
            ToolTip.text: "Fuel is running out"
            ToolTip.visible: indicator ? ma.containsMouse : false
            MouseArea {
                id: ma
                anchors.fill: parent
                hoverEnabled: true
            }
            source: indicator ? "qrc:/assets/fuel_red.svg" : "qrc:/assets/fuel.svg"
            opacity: indicator ? 0 : 1
            anchors{
                right: battery.left
                rightMargin: 15
                top: battery.bottom
                topMargin: 30
            }
            SequentialAnimation {
                running: fuel.indicator
                loops: Animation.Infinite
                OpacityAnimator {
                    target: fuel
                    from: 0;
                    to: 1;
                    duration: 700
                }
                OpacityAnimator {
                    target: fuel
                    from: 1;
                    to: 0;
                    duration: 700
                }
            }
        }

        Image{
            id:light
            width: 50
            height: 50
            ToolTip.text: "Lights are on"
            ToolTip.visible: indicator ? mouse.containsMouse : false
            MouseArea {
                id: mouse
                anchors.fill: parent
                hoverEnabled: true
            }
            property bool indicator
            source: indicator ? "qrc:/assets/light_green.svg" : "qrc:/assets/light.svg"
            anchors{
                right: fuel.left
                rightMargin: -25
                verticalCenter: fuel.verticalCenter
                verticalCenterOffset: 90
            }
        }

        Image {
            id: camera
            property string state : "good"
            width: 50
            height: 50
            ToolTip.text: state === "good" ? "Camera is available" : state === "warning" ? "Camera is not working well" : "Camera is out"
            ToolTip.visible: cameraMA.containsMouse
            MouseArea {
                id: cameraMA
                anchors.fill: parent
                hoverEnabled: true
            }
            source: state == "good" ? "qrc:/assets/camera_green.svg" : state == "warning" ? "qrc:/assets/camera_yellow.svg" : "qrc:/assets/camera_red.svg"
            anchors
            {
                left: topBar.right
                leftMargin: 200
                verticalCenter: topBar.verticalCenter
                verticalCenterOffset: 40
            }
        }

        Image {
            id: radio
            property string state : "good"
            width: 50
            height: 50
            ToolTip.text: state === "good" ? "Radio signals are good" : state === "weak" ? "Radio signals are weak" : "Radio signals are strong"
            ToolTip.visible: radioMA.containsMouse
            MouseArea {
                id: radioMA
                anchors.fill: parent
                hoverEnabled: true
            }
            source: state == "good" ? "qrc:/assets/radio_orange.svg" : state == "weak" ? "qrc:/assets/radio_red.svg" : "qrc:/assets/radio_green.svg"
            anchors{
                left: camera.left
                leftMargin: 35
                top: camera.bottom
                topMargin: 30
            }
        }

        Image{
            id:controlPanel
            width: 50
            height: 50
            ToolTip.text: indicator ? "Panel is fine" : "Panel is not fine"
            ToolTip.visible: panelMA.containsMouse
            MouseArea {
                id: panelMA
                anchors.fill: parent
                hoverEnabled: true
            }
            property bool indicator : true
            source: indicator ? "qrc:/assets/panel_green.svg" : "qrc:/assets/panel_red.svg"
            anchors{
                left: radio.right
                leftMargin: -25
                verticalCenter: radio.verticalCenter
                verticalCenterOffset: 90
            }
        }

        Rectangle{
            id: rect
            width: 500
            height: 50
            radius: 10
            color: "gray"
            border.color: "black"
            Text {
                id: info
                font.pixelSize: 15
                font.bold: Font.DemiBold
                property int i: 0
                property var progress: 0
                property bool start: false
                opacity: 1 - progress
                text: stringListModel.get(i).text
                anchors{
                    horizontalCenter: rect.horizontalCenter
                    verticalCenter: rect.verticalCenter
                }

                NumberAnimation on progress {
                    running: info.start
                    from: 0.0
                    to: 1.0
                    duration: 500
                }
                NumberAnimation on progress {
                    running: !info.start
                    from: 1.0
                    to: 0.0
                    duration: 1500
                }

                ListModel {
                    id: stringListModel
                    ListElement { text: "Press Ctrl + Q to quit" }
                    ListElement { text: "Press L to change lights state" }
                    ListElement { text: "Press C to change camera state" }
                    ListElement { text: "Press R to change radio signals state" }
                    ListElement { text: "Press P to change control panel state" }
                    ListElement { text: "Press shift to increase speed" }
                    ListElement { text: "Press right key to increase inside temperature" }
                    ListElement { text: "Press left key to decrease inside temperature" }
                    ListElement { text: "Press key 6 to increase outside temperature" }
                    ListElement { text: "Press key 4 to decrease outside temperature" }
                    ListElement { text: "Press PgUp key to increase battery charge" }
                    ListElement { text: "Press PgDn key to decrease battery charge" }
                    ListElement { text: "Press key 8 to increase the amount of fuel" }
                    ListElement { text: "Press key 2 to decrease the amount of fuel" }
                }

            }
            anchors{
                horizontalCenter: panel.horizontalCenter
                leftMargin: 250
                bottom: parent.bottom
                bottomMargin: 26.50 + 65
            }

            Behavior on width { NumberAnimation { duration: 1000 }}

        }

        Flipable{
            id: flip
            property bool flipped: true
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            back :Gauge {
                id: speedGauge
                property bool accelerating
                value: accelerating ? maximumValue : 0
                maximumValue: 220
                width: 450
                height: 450
                anchors.top: parent.top
                anchors.topMargin: -300
                anchors.horizontalCenter: parent.horizontalCenter
                Component.onCompleted: forceActiveFocus()

                Behavior on value { NumberAnimation { duration: 1000 }}

                Keys.onSpacePressed: accelerating = true
                Keys.onLeftPressed: leftGauge.accelerating  = -1
                Keys.onRightPressed: leftGauge.accelerating = 1
                Keys.onDigit6Pressed: rightGauge.accelerating = 1
                Keys.onDigit4Pressed: rightGauge.accelerating = -1
                Keys.onUpPressed: batteryIndicator.state = "Up"
                Keys.onDownPressed: batteryIndicator.state = "Down"
                Keys.onDigit8Pressed: fuelIndicator.state = "Up"
                Keys.onDigit2Pressed: fuelIndicator.state = "Down"

                Keys.onReleased: {
                    if (event.key === Qt.Key_Space) {
                        accelerating = false;
                    }else if(event.key === Qt.Key_Left || event.key === Qt.Key_Right){
                        leftGauge.accelerating = 0;
                    }else if(event.key === Qt.Key_6 || event.key === Qt.Key_4){
                        rightGauge.accelerating = 0;
                    }else if(event.key === Qt.Key_Up || event.key === Qt.Key_Down){
                        batteryIndicator.state = "";
                    }else if(event.key === Qt.Key_8 || event.key === Qt.Key_2){
                        fuelIndicator.state = "";
                    }

                }

                Keys.onPressed: {
                    if(event.key === Qt.Key_L){
                        light.indicator = !light.indicator
                    }else if(event.key === Qt.Key_C){
                        if(camera.state === "good")
                            camera.state = "warning"
                        else if(camera.state === "warning")
                            camera.state = "error"
                        else
                            camera.state = "good"
                    }else if(event.key === Qt.Key_S){
                        if(bar.state === "slowest")
                            bar.state = "slow"
                        else if(bar.state === "slow")
                            bar.state = "median"
                        else if(bar.state === "median")
                            bar.state = "fast"
                        else if(bar.state === "fast")
                            bar.state = "fastest"
                        else
                            bar.state = "slowest"
                    }else if(event.key === Qt.Key_R){
                        if(radio.state === "good")
                            radio.state = "strong"
                        else if(radio.state === "strong")
                            radio.state = "weak"
                        else
                            radio.state = "good"
                    }else if(event.key === Qt.Key_P){
                        controlPanel.indicator = !controlPanel.indicator
                    }
                }


                Label{
                    text: speedGauge.value <= 44 ? "SLOWEST" : speedGauge.value <= 88 ? "SLOW" : speedGauge.value <= 132 ? "MEDIAN" : speedGauge.value <= 176 ? "FAST" : "FASTEST"
                    font.pixelSize: 12
                    font.family: "Inter"
                    color: "white"
                    anchors.top: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: -35
                }

                RowLayout{
                    id: bar
                    spacing: 1
                    Layout.topMargin: 10
                    property string state: speedGauge.value <= 44 ? "slowest" : speedGauge.value <= 88 ? "slow" : speedGauge.value <= 132 ? "median" : speedGauge.value <= 176 ? "fast" : "fastest"
                    anchors{
                        horizontalCenter: parent.horizontalCenter
                        leftMargin: 250
                        bottom: parent.bottom
                        bottomMargin: 40
                    }
                    Rectangle{
                        width: 15
                        height: 15
                        radius: 5
                        color: bar.state == "slowest" ? "green" : "#01E6DC"
                    }
                    Rectangle{
                        width: 15
                        height: 15
                        radius: 5
                        color: bar.state == "slow" ? "light green" : "#01E6DC"
                    }
                    Rectangle{
                        width: 15
                        height: 15
                        radius: 5
                        color: bar.state == "median" ? "yellow" : "#01E6DC"
                    }
                    Rectangle{
                        width: 15
                        height: 15
                        radius: 5
                        color: bar.state == "fast" ? "orange" : "#01E6DC"
                    }
                    Rectangle{
                        width: 15
                        height: 15
                        radius: 5
                        color: bar.state == "fastest"? "red" : "#01E6DC"
                    }
                }
            }

            front: Image {
                source: "qrc:/assets/logo.png"
                width: 750
                height: 500
                anchors.top: parent.top
                anchors.topMargin: -300
                anchors.horizontalCenter: parent.horizontalCenter
            }

            transform: Rotation {
                id: rotation
                origin.x: flip.width / 2
                origin.y: flip.height / 2
                axis.x: 0; axis.y: 1; axis.z: 0
                angle: 0
            }

            states: State {
                name: 'back'
                when: flip.flipped

                PropertyChanges { target: rotation; angle: 180 }
            }

            transitions: Transition {
                NumberAnimation {
                    target: rotation
                    property: 'angle'
                    duration: 3000
                    easing.type: Easing.InCubic
                }
            }
        }

        SideGauge {
            id:leftGauge
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: parent.width / 7
            }
            property var accelerating : -2
            width: 400
            height: 400
            opacity: 0
            value: accelerating === 1 ? maximumValue : accelerating === 0 ? value : accelerating === -2 ? 20 : 0
            maximumValue: 100
            Component.onCompleted: forceActiveFocus()
            lableText : "C°"
            gaugeName : " Inside Temperature"
            Behavior on value { NumberAnimation { duration: 3000 }}
        }



        SideGauge {
            id:rightGauge
            anchors{
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: parent.width / 7
            }
            property var accelerating : -2
            width: 400
            height: 400
            opacity: 0
            value: accelerating === 1 ? maximumValue : accelerating === 0 ? value : accelerating === -2 ? 20 : 0
            maximumValue: 100
            Component.onCompleted: forceActiveFocus()
            lableText : "C°"
            gaugeName : "  Outside Temperature"
            Behavior on value { NumberAnimation { duration: 3000 }}
        }

        Image{
            source: "qrc:/assets/desal.svg"
            anchors.bottom: fuelIndicator.top
            anchors.right: fuelIndicator.right
            sourceSize: Qt.size(48,48)
            anchors.bottomMargin: 5
        }

        Image{
            id:fuelIndicator
            property string state
            property real value
            value: state === "Up" ? 0 : state === "Down" ? 1 : value
            Behavior on value { NumberAnimation { duration: 1000 }}
            source:  "qrc:/assets/Vector 1.png"
            mirror: true
            anchors.left: rightGauge.right
            anchors.leftMargin: -150
            anchors.top: rightGauge.bottom
            anchors.topMargin: -50
            smooth: true
            asynchronous: true
            layer.enabled: true
            layer.samplerName: "fuelShader"
            layer.effect: ShaderEffect {
                id: fuelShaderMask2
                property variant v
                v: fuelIndicator.value

                fragmentShader: "
                     uniform lowp sampler2D fuelShader;
                     uniform lowp float qt_Opacity;
                     varying highp vec2 qt_TexCoord0;
                     uniform lowp float v;

                     void main() {
                        const lowp vec3 c1 = vec3(0.502,0.545,0.11);
                        const lowp vec3 c2 = vec3(0.247,0.78,0.871);
                        lowp vec3 bg = mix(c1, c2, 1.0 - qt_TexCoord0.y);

                        // Animated ramp
                        lowp float s = smoothstep(0.99 - v, 1.01 - v, 1.0 - qt_TexCoord0.y);
                        lowp vec3 ramp = vec3(s);
                        lowp vec4 color = vec4(bg + ramp, 1.0);

                        gl_FragColor = color * texture2D(fuelShader, qt_TexCoord0).a * qt_Opacity;
                     }
                 "
            }
        }

        Image{
            source: "qrc:/assets/batteryIcon.svg"
            anchors.bottom: batteryIndicator.top
            anchors.left: batteryIndicator.left
            anchors.bottomMargin: 10
        }

        Image{
            id:batteryIndicator
            property string state
            property real value
            value: state === "Up" ? 0 : state === "Down" ? 1 : value
            Behavior on value { NumberAnimation { duration: 1000 }}
            source: "qrc:/assets/Vector 1.png"
            anchors.right: leftGauge.left
            anchors.top: leftGauge.bottom
            anchors.rightMargin: -150
            anchors.topMargin: -50
            layer.enabled: true
            layer.samplerName: "fuelShader"
            layer.effect: ShaderEffect {
                id: fuelShaderMask
                property variant v
                v: batteryIndicator.value

                fragmentShader: "
                     uniform lowp sampler2D fuelShader;
                     uniform lowp float qt_Opacity;
                     varying highp vec2 qt_TexCoord0;
                     uniform lowp float v;

                     void main() {
                        const lowp vec3 c1 = vec3(0.502,0.545,0.11);
                        const lowp vec3 c2 = vec3(0.247,0.78,0.871);
                        lowp vec3 bg = mix(c1, c2, 1.0 - qt_TexCoord0.y);

                        // Animated ramp
                        lowp float s = smoothstep(0.99 - v, 1.01 - v, 1.0 - qt_TexCoord0.y);
                        lowp vec3 ramp = vec3(s);
                        lowp vec4 color = vec4(bg + ramp, 1.0);

                        gl_FragColor = color * texture2D(fuelShader, qt_TexCoord0).a * qt_Opacity;
                     }
                 "
            }
        }



    }


}

