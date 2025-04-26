#!/bin/bash

hyprctl clients -j | jq -r ".[] | select(.workspace.id == $(hyprctl activeworkspace -j | jq .id)) | .pid" | xargs -r -I{} hyprctl dispatch killwindow pid:{}
