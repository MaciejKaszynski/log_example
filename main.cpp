#include "score/mw/log/log_stream.h"
#include "score/mw/log/logger.h"
#include "score/mw/log/logging.h"

#include <chrono>
#include <cstdint>
#include <thread>

// logging for custom type
struct Point
{
    int x;
    int y;
};

score::mw::log::LogStream& operator<<(score::mw::log::LogStream& stream, const Point& p)
{
    return stream << "Point(" << p.x << "," << p.y << ")";
}

int main()
{
    score::mw::log::Logger& main_log = score::mw::log::CreateLogger("MAIN", "Main context");
    score::mw::log::Logger& sens_log = score::mw::log::CreateLogger("SENS", "Sensor context");
    score::mw::log::Logger& netw_log = score::mw::log::CreateLogger("NETW", "Network context");

    main_log.LogFatal() << "Remote logging demo starting — FATAL marker to confirm DLT connection";
    main_log.LogError() << "AppId: DEMO  logMode: kRemote  logLevel: kVerbose";

    sens_log.LogError() << "Sensor subsystem initialised";
    netw_log.LogError() << "Network subsystem initialised";

    std::uint32_t counter{0U};
    float temperature{20.5F};

    while (counter < 30U)
    {
        main_log.LogInfo() << "Loop iteration" << counter << Point{static_cast<int>(counter), static_cast<int>(counter * 2U)};

        temperature += 0.3F;
        sens_log.LogInfo() << "Temperature reading:" << temperature << "degC";

        if ((counter % 5U) == 0U)
        {
            sens_log.LogError() << "Temperature threshold crossed:" << temperature;
        }

        const std::uint32_t packet_id{counter * 4U + 0xA000U};
        netw_log.LogInfo() << "Sending packet id:" << score::mw::log::LogHex32{packet_id}
                           << "size:" << static_cast<std::int32_t>(counter + 64U) << "bytes";

        if ((counter % 10U) == 0U)
        {
            netw_log.LogFatal() << "Simulated network error at iteration" << counter;
        }

        ++counter;
        std::this_thread::sleep_for(std::chrono::seconds(1));
    }

    main_log.LogInfo() << "Demo finished after" << counter << "iterations";
    return 0;
}
