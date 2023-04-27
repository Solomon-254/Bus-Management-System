// ignore_for_file: constant_identifier_names
const RootRoute = "/";

const DashboardPageDisplayName = "Dashboard";
const DashboardViewRoute = "/dashboard";

const BusesPageDisplayName = "Buses";
const BusesViewRoute = "/buses";

const UsersViewRoute = "/users";
const UsersPageDisplayName = "Users";

const HistoryViewRoute = "/events";
const HistoryPageDisplayName = "Events";

const RoutesPageDisplayName = "Routes";
const RoutesViewsRoutes = "/routes";

const SettingsViewRoute = "/settings";
const SettingsPageDisplayName = "Settings";

const AddBusesRoute = "/AddBus";

const AddEventsRoute = "/AddEvents";

const AddUsersRoute = "/AddUsers";

const AddRoutesRoute = "/AddRoute";

const DownloadBusFilesRoute = '/DownloadBusFiles';

const AuthenticationViewRoute = "/Login";
const AuthenticationDisplayName = "Log Out";

class MenuItem {
  final String name;
  final String route;
  MenuItem(this.name, this.route);
}

List<MenuItem> panelMenuItems = [
  MenuItem(DashboardPageDisplayName, DashboardViewRoute),
  MenuItem(BusesPageDisplayName, BusesViewRoute),
  MenuItem(UsersPageDisplayName, UsersViewRoute),
  MenuItem(HistoryPageDisplayName, HistoryViewRoute),
  MenuItem(RoutesPageDisplayName, RoutesViewsRoutes),
  MenuItem(SettingsPageDisplayName, SettingsViewRoute),
  MenuItem(AuthenticationDisplayName, AuthenticationViewRoute)
];

class AddItem {
  final String route;
  AddItem(this.route);
}
