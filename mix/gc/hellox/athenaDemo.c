#include <stdio.h>

#include <X11/Intrinsic.h>
#include <X11/StringDefs.h>
#include <X11/Xaw/Command.h>
#include <X11/Xaw/Form.h>
#include <X11/Xaw/Box.h>

/*  exit the program */

static void exitHandler(Widget w, XtPointer callData, XtPointer clientData)
  {
  exit(0);
  }

/* print "hello" to stdout */

static void helloHandler(Widget w, XtPointer callData, XtPointer clientData)
  {
  printf("Hello\n");
  }

/* main program */

void main(int argc, char **argv)
  {
  XtAppContext appContext;
  Widget toplevel, box, topLabel, bottomPanel, helloButton, exitButton;

  toplevel = XtVaAppInitialize(&appContext, "AthenaDemo", NULL, 0, &argc, argv, NULL, NULL);

  box = XtVaCreateManagedWidget("box",boxWidgetClass,toplevel,NULL);
  
  topLabel = XtVaCreateManagedWidget("topLabel", labelWidgetClass, box,
				     XtNlabel," Pick One ",
				     XtNborderWidth, 0,
				     NULL);
  
  bottomPanel = XtVaCreateManagedWidget("bottomPanel", formWidgetClass, box,
					XtNsensitive, True,
					XtNborderWidth, 0,
					NULL);

  helloButton = XtVaCreateManagedWidget("helloButton", commandWidgetClass, bottomPanel,
					XtNlabel," Hello ",
					NULL);

  XtAddCallback(helloButton, XtNcallback, helloHandler, NULL);

  exitButton = XtVaCreateManagedWidget("exitButton", commandWidgetClass, bottomPanel,
				       XtNlabel," Exit ",
				       XtNfromHoriz,helloButton,
				       NULL);

  XtAddCallback(exitButton, XtNcallback, exitHandler, NULL);
  XtRealizeWidget(toplevel);
  XtAppMainLoop(appContext);
  }
