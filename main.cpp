 #include "score/mw/log/logger.h" 

int main()
{
    auto logger = score::mw::log::CreateLogger("LOG", "My Logger");

    logger.LogFatal() << "Hello";
}
