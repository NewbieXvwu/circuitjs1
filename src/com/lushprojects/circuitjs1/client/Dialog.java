/*    
    Copyright (C) Paul Falstad and Iain Sharp
    
    This file is part of CircuitJS1.

    CircuitJS1 is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    CircuitJS1 is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with CircuitJS1.  If not, see <http://www.gnu.org/licenses/>.
*/

package com.lushprojects.circuitjs1.client;


import com.google.gwt.user.client.ui.DialogBox;
import com.google.gwt.user.client.ui.Widget;

class Dialog extends DialogBox  {

    boolean closeOnEnter;

    Dialog() {
        closeOnEnter = true;
        addStyleName("md3-dialog");
        setAnimationEnabled(true);
        setGlassEnabled(true);
    }

    @Override
    public void setWidget(Widget w) {
        Widget current = getWidget();
        if (current != null) {
            current.removeStyleName("dialogContent");
        }
        super.setWidget(w);
        if (w != null) {
            w.addStyleName("dialogContent");
        }
    }

    public void closeDialog()
    {
        hide();
        if (CirSim.dialogShowing == this)
            CirSim.dialogShowing = null;
    }
    
    
    public void enterPressed() {
        if (closeOnEnter) {
        apply();
        closeDialog();
        }
    }

    void apply() {
    }
}

