from kiwi.ui.test.player import Player

player = Player(['bin/stoq', 'receivable'])
app = player.get_app()

player.wait_for_window("ReceivableApp")
app.ReceivableApp.users_menu.activate()
app.ReceivableApp.ClearCookie.activate()
app.ReceivableApp.users_menu.activate()
app.ReceivableApp.StoreCookie.activate()
app.ReceivableApp.search_button.clicked()
app.ReceivableApp.receivables.select_paths([(0, )])
app.ReceivableApp.receivables.select_paths([])
app.ReceivableApp.filter_combo.select_item_by_label("Cancelled")
app.ReceivableApp.filter_combo.select_item_by_label("Confirmed")
app.ReceivableApp.filter_combo.select_item_by_label("Reviewing")
app.ReceivableApp.filter_combo.select_item_by_label("Paid")
app.ReceivableApp.filter_combo.select_item_by_label("To Pay")
app.ReceivableApp.receivables.select_paths([(0, )])
app.ReceivableApp.filter_combo.select_item_by_label("Preview")
app.ReceivableApp.TillMenu.activate()
app.ReceivableApp.TillMenu.activate()
app.ReceivableApp.quit_action.activate()
player.finish()