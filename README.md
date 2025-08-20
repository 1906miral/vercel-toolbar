# Vercel Toolbar

A sleek macOS menu bar application for viewing your Vercel deployments in real-time.

![Vercel Toolbar](https://img.shields.io/badge/macOS-15.5+-black?style=flat-square&logo=apple)
![Swift](https://img.shields.io/badge/Swift-5.0+-orange?style=flat-square&logo=swift)
![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0+-blue?style=flat-square&logo=swift)

## Demo


https://github.com/user-attachments/assets/32b21407-1825-4d1c-8e07-9d533a4abfc8


## Features

- 🚀 **Real-time deployment monitoring** - View your latest Vercel deployments
- 🔄 **Auto-refresh** - Updates every 30 seconds automatically  
- 📱 **Menu bar integration** - Clean triangle icon in your menu bar
- ⚙️ **Simple setup** - Just add your Vercel access token
- 🎨 **Native macOS design** - Follows system design patterns
- 🌙 **Background app** - Runs quietly without cluttering your dock
- 🔐 **Secure token storage** - Your access token is stored safely in UserDefaults
- 🖱️ **Right-click menu** - Enable start at login and quit options

## Installation

1. Download the latest release from [Releases](../../releases)
2. Move `Vercel Toolbar.app` to your Applications folder
3. Launch the app - you'll see a triangle icon in your menu bar
4. Click the gear icon to add your Vercel access token
5. Get your token from [vercel.com/account/settings/tokens](https://vercel.com/account/settings/tokens)

## Usage

- **Left-click** the triangle icon → View deployments
- **Right-click** the triangle icon → App settings (start at login, quit)
- **Settings** → Configure your Vercel access token
- **Made by Ryan V** → Links to creator's profile

## App Architecture

```
vercel-toolbar/
├── vercel_toolbarApp.swift       # Main app entry point & menu bar setup
├── DeploymentsView.swift         # Main deployments list UI
├── SettingsView.swift            # Token configuration UI  
├── VercelService.swift           # API service & polling logic
├── VercelModels.swift            # Data models for Vercel API
├── TriangleIcon.swift            # Custom menu bar icon
├── FontManager.swift             # Geist font integration
├── Assets.xcassets/              # App icon & black accent color
└── Info.plist                    # Background app configuration
```

### Key Components

- **AppDelegate**: Manages menu bar item, popover, and right-click context menu
- **VercelService**: Handles API calls, caching, and 30-second polling
- **DeploymentsView**: Main UI showing deployment list with status badges
- **SettingsView**: Simple token input with instructions
- **Models**: Clean data structures matching Vercel API responses

## Contributing

We welcome contributions! Here's how to get started:

### Development Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/R44VC0RP/vercel-toolbar.git
   cd vercel-toolbar
   ```

2. **Open in Xcode**
   ```bash
   open vercel-toolbar.xcodeproj
   ```

3. **Requirements**
   - macOS 13.0+
   - Xcode 15.0+
   - Swift 5.0+

### Development Guidelines

- **Code Style**: Follow Swift conventions, use meaningful variable names
- **UI/UX**: Maintain native macOS look and feel with SwiftUI
- **Performance**: Keep the app lightweight and responsive
- **Testing**: Test with real Vercel deployments before submitting

### Making Contributions

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes**
   - Add features or fix bugs
   - Update documentation if needed
   - Follow existing code patterns
4. **Test thoroughly**
   - Build and run the app
   - Test with your Vercel account
   - Verify menu bar interactions work
5. **Commit your changes**
   ```bash
   git commit -m "Add amazing feature"
   ```
6. **Push to your fork**
   ```bash
   git push origin feature/amazing-feature
   ```
7. **Open a Pull Request**

### What We're Looking For

- 🐛 **Bug fixes** - Help us squash issues
- ✨ **UI improvements** - Make the app more beautiful
- ⚡ **Performance optimizations** - Keep it fast and efficient
- 📚 **Documentation** - Improve README or code comments
- 🧪 **Testing** - Add test coverage
- 🎨 **Design enhancements** - Better icons, animations, etc.

### Reporting Issues

Found a bug? Have a feature request? Please open an issue with:
- Clear description of the problem/request
- Steps to reproduce (for bugs)
- Your macOS version and app version
- Screenshots if applicable

## Technical Details

- **Built with**: Swift, SwiftUI, Foundation
- **Architecture**: MVVM pattern with ObservableObject services
- **API**: Vercel REST API v6 with Bearer token authentication
- **Storage**: UserDefaults for token and cached data
- **Polling**: 30-second intervals with configurable refresh
- **Menu Bar**: NSStatusItem with NSPopover for clean integration

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Made by Ryan V** - [@ryandavogel](https://x.com/ryandavogel)

---

*This is an unofficial third-party application and is not affiliated with Vercel Inc.*
