package com._1935711.mycardlet;

import javacard.framework.*;
import sim.toolkit.*;

public class MyCardlet extends Applet implements ToolkitInterface, ToolkitConstants {
	/*
	 * Sysmocom-SJA2 flash memory has 500,000 write cycles, so keep these
	 * variables to a bare minimum.
	 */
	static private byte[] helloText = new byte[] { 'H', 'e', 'l', 'l', 'o', ',', ' ', 'W', 'o', 'r', 'l', 'd', '!' };
	private byte helloMenuItem;

	private MyCardlet() {
		/*
		 * This is the interface to the STK applet registry (which is separate
		 * from the JavaCard applet registry).
		 */
		ToolkitRegistry toolkitRegistry = ToolkitRegistry.getEntry();

		helloMenuItem = toolkitRegistry.initMenuEntry(helloText, (short) 0, (short) helloText.length,
				PRO_CMD_SELECT_ITEM, false, (byte) 0, (short) 0);
	}

	/*
	 * JCRE calls `install` to create ann instance of the Java Card applet and
	 * give it control. This is called when the applet is being installed.
	 */
	public static void install(byte[] bArray, short bOffset, byte bLength) {
		MyCardlet applet = new MyCardlet();
		applet.register();
	}

	/*
	 * This processes APDUs sent directly to the applet. For STK applets, this
	 * interface isn't really used.
	 */
	public void process(APDU arg0) throws ISOException {
		/* Ignore the applet select command dispached to the process. */
		if (selectingApplet()) {
			return;
		}
	}

	/* This processes STK events. */
	public void processToolkit(byte event) throws ToolkitException {
		ProactiveHandler proactiveHandler = ProactiveHandler
				.getTheHandler();

		if (event == EVENT_MENU_SELECTION) {
			EnvelopeHandler eventHandler = EnvelopeHandler.getTheHandler();
			byte selectItemId = eventHandler.getItemIdentifier();

			if (selectItemId == helloMenuItem) {
				proactiveHandler.initDisplayText((byte) 0, DCS_8_BIT_DATA, helloText, (short) 0,
						(short) helloText.length);
				proactiveHandler.send();
			}
		}
	}
}
