using System.ServiceProcess;

namespace ScreenSentinel.WindowsService;

public static class Program
{
    public static void Main(string[] args)
    {
        ServiceBase.Run(new ScreenSentinelService());
    }
}